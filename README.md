# ActiveApi

[![Build Status](https://travis-ci.org/blairanderson/active_api.svg)](https://travis-ci.org/blairanderson/active_api)

ActiveApi brings convention over configuration to help you provide a smart JSON API and documentation.

ActiveApi wraps [https://github.com/rails-api/active_model_serializers](rails-api/active_model_serializers),
[will_paginate](https://github.com/mislav/will_paginate),
[has_scope](https://github.com/plataformatec/has_scope), and [api-documentation](api-documentation)!

# MAINTENANCE, PLEASE READ

This is undergoing heavy development.

TODOs:
- Swagger spec from `1.2` to `2.0`
- Add serializer details to swagger spec
- add collection routes
- add member routes

## Setup

```ruby

#Gemfile

gem 'active_model_serializers'
gem 'active_api', github: 'blairanderson/active_api'

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

$ rake routes

Routes for ActiveApi::Engine:
item_comments GET    /items/:item_id/comments(.:format)     active_api/nested_active_api#index {:model=>"Comment", :resources=>"comments", :parent_resource=>:items}
              POST   /items/:item_id/comments(.:format)     active_api/nested_active_api#create {:model=>"Comment", :resources=>"comments", :parent_resource=>:items}
 item_comment GET    /items/:item_id/comments/:id(.:format) active_api/nested_active_api#show {:model=>"Comment", :resources=>"comments", :parent_resource=>:items}
              PATCH  /items/:item_id/comments/:id(.:format) active_api/nested_active_api#update {:model=>"Comment", :resources=>"comments", :parent_resource=>:items}
              PUT    /items/:item_id/comments/:id(.:format) active_api/nested_active_api#update {:model=>"Comment", :resources=>"comments", :parent_resource=>:items}
              DELETE /items/:item_id/comments/:id(.:format) active_api/nested_active_api#destroy {:model=>"Comment", :resources=>"comments", :parent_resource=>:items}
        items GET    /items(.:format)                       active_api/active_api#index {:model=>"Item", :resources=>"items"}
              POST   /items(.:format)                       active_api/active_api#create {:model=>"Item", :resources=>"items"}
         item GET    /items/:id(.:format)                   active_api/active_api#show {:model=>"Item", :resources=>"items"}
              PATCH  /items/:id(.:format)                   active_api/active_api#update {:model=>"Item", :resources=>"items"}
              PUT    /items/:id(.:format)                   active_api/active_api#update {:model=>"Item", :resources=>"items"}
              DELETE /items/:id(.:format)                   active_api/active_api#destroy {:model=>"Item", :resources=>"items"}
        users GET    /users(.:format)                       active_api/active_api#index {:model=>"User", :resources=>"users", :serializer=>"human"}
              POST   /users(.:format)                       active_api/active_api#create {:model=>"User", :resources=>"users", :serializer=>"human"}
         user GET    /users/:id(.:format)                   active_api/active_api#show {:model=>"User", :resources=>"users", :serializer=>"human"}
              PATCH  /users/:id(.:format)                   active_api/active_api#update {:model=>"User", :resources=>"users", :serializer=>"human"}
              PUT    /users/:id(.:format)                   active_api/active_api#update {:model=>"User", :resources=>"users", :serializer=>"human"}
              DELETE /users/:id(.:format)                   active_api/active_api#destroy {:model=>"User", :resources=>"users", :serializer=>"human"}
         root GET    /                                      active_api/application#root


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
