ActiveApi::Engine.routes.draw do

  route_resources = ActiveApi::Engine.config.route_config[:resources]
  # for each top level resource, route to top_level controller
  route_resources.each do |r|
    resources r, controller: 'top_levels', resource: r.to_s, model: r.to_s.singularize.capitalize
  end

  root to: 'application#root'
end

