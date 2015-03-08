# ActiveApi

[![Build Status](https://travis-ci.org/blairanderson/active_api.svg)](https://travis-ci.org/blairanderson/active_api)

ActiveApi brings convention over configuration to provide a JSON API.

ActiveApi wraps [https://github.com/rails-api/active_model_serializers](rails-api/active_model_serializers),
[will_paginate](https://github.com/mislav/will_paginate),
[has_scope](https://github.com/plataformatec/has_scope), and [api-documentation](api-documentation)!

# MAINTENANCE, PLEASE READ

This is the master branch of ActiveApi. Its going to be released when AMS hits `0.10.0`.

## Setup

```ruby

#Gemfile

gem 'active_model_serializers'
gem 'active_api'

```

```shell

$ bundle
$ bundle exec rails generate active_api:install

````

Configure your routes!


```ruby

ActiveApi::Engine.config.route_config = [
  {
    resources: 'items',
    do: [
      {
        resources: 'comments'
      }
    ]
  },
  {
    resources: 'users',
    serializer: 'human'
  }
]

```

View the new routes!

```shell

rake routes

```
The route config takes all options that a normal route can, including nested routes;


### Specify a serializer

[ActiveModel::Serializers](rails_api/active_model_serializers)


## Create a Serializer from Config

TODO:


## Exporting Serializer Config

TODO:


## Caching

TODO:

## Getting Help

If you find a bug, please report an [Issue](https://github.com/blairanderson/active_api/issues/new).

If you have a question, please [post to Stack Overflow](http://stackoverflow.com/questions/tagged/active-api).

Thanks!

## Contributing

1. Fork it ( https://github.com/blairanderson/active_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
