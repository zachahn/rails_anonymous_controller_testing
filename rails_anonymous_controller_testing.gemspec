require_relative "lib/rails_anonymous_controller_testing/version"

Gem::Specification.new do |spec|
  spec.name = "rails_anonymous_controller_testing"
  spec.version = RailsAnonymousControllerTesting::VERSION
  spec.authors = ["Zach Ahn"]
  spec.email = ["engineering@zachahn.com"]
  spec.homepage = "https://github.com/zachahn/rails_anonymous_controller_testing"
  spec.summary = "Rails test helpers for testing anonymous controllers (Minitest only!)"
  spec.description = spec.summary
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/zachahn/rails_anonymous_controller_testing/blob/main/CHANGELOG.md"

  spec.files = Dir["lib/**/*.rb", "LICENSE", "README.md"]

  spec.add_dependency "actionpack", ">= 5.0.0"

  spec.add_development_dependency "rails", ">= 5.0.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
end
