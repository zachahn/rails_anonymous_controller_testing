class RailsAnonymousControllerTesting::Railtie < ::Rails::Railtie
  config.before_initialize do
    ActiveSupport.on_load(:action_dispatch_integration_test) do
      ANONYMOUS_PATH_MUTEX = Mutex.new

      def self._anonymous_view_base_path
        @_anonymous_view_base_path ||= Rails.root.join("tmp", "anonymous_controller_views")
      end

      def self.anonymous_view_base_path=(value)
        @_anonymous_view_base_path = value
      end

      def self._anonymous_controller_name
        @_anonymous_controller_name ||= "AnonymousController"
      end

      def self._anonymous_view_cache?
        if instance_variable_defined?(:@_anonymous_view_cache)
          @_anonymous_view_cache
        end

        @_anonymous_view_cache = true
      end

      def self.disable_anonymous_view_cache!
        @_anonymous_view_cache = false
      end

      def self.enable_anonymous_view_cache!
        @_anonymous_view_cache = true
      end

      def self.views
        @_anonymous_views ||= {}
      end

      def self.views=(value)
        @_anonymous_views = value
      end

      def self.controller(base_controller, routes: nil, &block)
        caller_location = caller_locations(1, 10).find { |location| location.absolute_path != __FILE__ }

        display_name =
          if caller_location
            "#{caller_location.absolute_path.split("/").last.split(".").first}_#{caller_location.lineno}"
          else
            "path_unknown"
          end

        unique_identifier =
          if caller_location
            Digest::MD5
              .file(caller_location.absolute_path)
              .tap { |d| d << caller_location.absolute_path }
              .tap { |d| d << caller_location.lineno.to_s }
          else
            SecureRandom.hex
          end

        anonymous_view_path = _anonymous_view_base_path.join("#{display_name}_#{unique_identifier}")
        anonymous_controller_name = _anonymous_controller_name

        # Define the controller
        anonymous_controller_class = Class.new(base_controller) do
          prepend_view_path(anonymous_view_path)

          define_singleton_method(:name) do
            anonymous_controller_name
          end
        end
        anonymous_controller_class.class_exec(&block)

        # Attach the controller to the test class
        const_set(anonymous_controller_name, anonymous_controller_class)

        setup do
          Rails.application.reload_routes!

          # Set up the routes
          if !routes
            resource_name = anonymous_controller_class.controller_name.to_sym
            resource_module = self.class.name.underscore

            routes = proc do
              resources(resource_name, module: resource_module)
            end
          end

          Rails.application.routes.send(:eval_block, routes)

          # Set up the views
          ANONYMOUS_PATH_MUTEX.synchronize do
            next if self.class.views.empty?
            next if self.class._anonymous_view_cache? && anonymous_view_path.exist?
            anonymous_view_path.mkpath

            self.class.views.each do |basename, contents|
              viewpath = anonymous_view_path.join(basename)
              if viewpath.dirname == anonymous_view_path
                viewpath = anonymous_view_path.join(anonymous_controller_class.controller_name, basename)
              end

              next if self.class._anonymous_view_cache? && viewpath.exist?

              viewpath.dirname.mkpath
              viewpath.write(contents)
            end
          end
        end

        teardown do
          # Reset the routes to its original state
          Rails.application.reload_routes!
        end
      end
    end
  end
end
