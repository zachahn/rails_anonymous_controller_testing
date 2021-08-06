# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.3] - 2021-08-06

### Added

* Support for multiple test classes in one file

## [0.0.2] - 2021-08-02

### Fixed

* Ensures that the `ActiveSupport.on_load(:action_dispatch_integration_test)`
  hook runs

## [0.0.1] - 2021-08-01

### Added

* Ability to create an anonymous controller in a Rails integration test
* Ability to create views for the controller
* A default `resources` route
* Ability to customize the route


[Unreleased]: https://github.com/zachahn/rails_anonymous_controller_testing/compare/v0.0.3...HEAD
[0.0.3]: https://github.com/zachahn/rails_anonymous_controller_testing/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/zachahn/rails_anonymous_controller_testing/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/zachahn/rails_anonymous_controller_testing/compare/v0.0.0...v0.0.1
