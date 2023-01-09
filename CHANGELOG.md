# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](Https://conventionalcommits.org) for commit guidelines.

<!-- changelog -->

## [1.3.0](https://github.com/smartrent/solicit/compare/1.2.2...1.3.0) (2023-01-09)

### Features:

* Add support for atoms to `Response.unprocessable_entity/2` ([#112](https://github.com/smartrent/solicit/pull/112))



## [1.2.2](https://github.com/smartrent/solicit/compare/1.2.1...1.2.2) (2022-03-24)

### Bug Fixes:

* Fixes `Solicit.Plugs.Validation.QueryParams` handling of nested maps ([#71](https://github.com/smartrent/solicit/pull/71))



## [1.2.1](https://github.com/smartrent/solicit/compare/1.2.0...1.2.1) (2022-02-22)




### Bug Fixes:

* handle format validation errors from a changeset to remove "unknown_error" responses

## [1.2.0](https://github.com/smartrent/solicit/compare/1.1.1...1.2.0) (2021-10-19)




### Features:

* add 502 and 503 responses (#48)

## [1.1.1](https://github.com/smartrent/solicit/compare/1.1.0...1.1.1) (2021-09-14)




### Bug Fixes:

* error when negative page and negative limit provided (#46)



## [1.1.0](https://github.com/smartrent/solicit/compare/1.0.15...1.1.0) (2021-09-07)




### Features:

* rewrite CastPathParam plug as ValidatePathParam (#42)

* add default description to conflict (#40)

* add default description to conflict

* use git_ops to help automate releases

* add UUID helpers

### Fixes:

* format DateTimes as ISO-8601 strings in JSON (#45)

## [1.0.12](https://github.com/smartrent/solicit/compare/1.0.12...1.0.12) (2021-06-11)




### Features:

* Add accepted/1 Function to Response Package

* ResponseError functions allow overriding default description
