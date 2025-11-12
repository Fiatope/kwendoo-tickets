# Neighborly::Api
[![Build Status](https://travis-ci.org/neighborly/neighborly-api.svg?branch=master)](https://travis-ci.org/neighborly/neighborly-api) [![Code Climate](https://codeclimate.com/github/neighborly/neighborly-api.png)](https://codeclimate.com/github/neighborly/neighborly-api)

## What

This is the implementation of [Neighborly](https://github.com/neighborly/neighborly)'s API.

## How

Include this gem as dependency of your project, adding the following line in your `Gemfile`.

```ruby
# Gemfile
gem 'neighborly-api'
```

Neighborly::Api is a Rails Engine, integrating with your (Neighborly) Rails application with very little of effort. To turn the engine on, mount it in an appropriate route:

```ruby
# config/routes.rb
#mount Neighborly::Api::Engine => '/api/', as: :neighborly_api
```

## Contributing

1. Fork it ( https://github.com/neighborly/neighborly-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Running specs

We prize for our test suite and coverage, so it would be great if you could run the specs to ensure that your patch is not breaking the existing codebase.

When running specs for the first time, you'll need to download Neighborly's source code to be tested against your version of the gem. The following command will install the dummy app in `spec/dummy`.

```
$ git submodule init
$ git submodule update
```

And before you go, you need to initialize a database for this "dummy" app.

```
$ cd spec/dummy/
$ ./bin/bootstrap
$ cd ../../
$ cp spec/dummy/.env.example .env
$ rm -rf spec/dummy/spec
```

To run the specs just run:

```
$ bundle exec rspec
```

## License

Licensed under the [MIT license](LICENSE.txt).