# Rails Anonymous Controller Testing

I sometimes want to test an abstract controller, a controller concern, a view,
or a helper method.

This might be useful for you if you're working on a Rails engine or if you're
editing your `ApplicationController`.

This only works with Minitest, specifically for tests that inherit from
`ActionDispatch::IntegrationTest`.


## Usage

Here's a relatively straightforward example. There are a few caveats you might
need to keep in mind for more complicated cases; see the Caveats section below.

```ruby
class MyControllerTest < ActionDispatch::IntegrationTest
  # 1. Call the `controller` method. You must specify the base controller to
  #    inherit from. It'll set up routes with `resources :anonymous`.
  controller(ApplicationController) do
    def index
    end

    def show
      render plain: params[:id]
    end
  end

  # 2. Optionally, set views. You can set the layout for your anonymous
  #    controller too.
  views["layouts/application.html.erb"] = <<~HTML
    <h1>My anonymous test</h1>
    <%= yield %>
  HTML

  views["index.html.erb"] = <<~HTML
    <h2>Hi</h2>
  HTML

  # 3. Test like it's a regular controller in your application
  def test_index
    get "/anonymous"
    assert_select "h1", "My anonymous test"
    assert_select "h2", "Hi"
  end

  def test_show
    get "/anonymous/1234"
    assert_equal "1234", response.body
  end
end
```

You can also specify the routes too, but you need to namespace the controller to
the name of the test class.

```ruby
class MyControllerTest < ActionDispatch::IntegrationTest
  routes = -> { get "custom", to: "my_controller_test/anonymous#custom" }
  controller(ApplicationController, routes: routes) do
    def custom
    end
  end
end
```


### Caveats

A few things to note

* You can only define **one** `controller do` per test class. But you can get
  around this limitation by defining another test class in one file.
* Views are generated only once and cached. The cache key is determined by MD5
  hashing the test file contents, and test file path, and the line number of the
  `controller do`.
* You can disable the view cache by calling `disable_anonymous_view_cache!` on
  your test class. This doesn't get around the limitation of having just one
  `controller do` definition in your test class.
* The view cache is located in `tmp/anonymous_controller_views` and can be
  cleared anytime
* Setting a custom layout will only affect your anonymous controller. This gem
  does not provide any way to affect the behavior of existing controllers
  defined by your Rails application or engine


## Installation

Add this line to your application's Gemfile:

```ruby
gem "rails_anonymous_controller_testing", group: :test
```

And then execute:

```bash
$ bundle
```


## Contributing

Contributions very welcome. Please give me edit access to your branch for a
faster turnaround.


## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
