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

# If you want to turn off documentation, set to false
# ActiveApi::Engine.config.documentation = false
ActiveApi::Engine.config.documentation = {
  title: "ActiveApi docs, Put your site name here",
  description: "StarterKit for a social/mobile/news/product site.",
  terms_of_service_url: "http://github.com/blairanderson/active_api",
  contact: "http://github.com/blairanderson/active_api/issues",
  license: "MIT",
  license_url: "http://github.com/blairanderson/active_api/tree/master/LICENSE.md"
}
