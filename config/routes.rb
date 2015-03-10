# I'd like to have coverage of all resources capability

# {
#   controller: "active_api",
#   resource: :items,
#   model: "Item",
#   format: :json,
#   path_names: {},
#   path: "",
#   only: :show,
#   only: [:show, :index],
#   except: :show,
#   except: [:show, :index],
#   shallow: true,
#   shallow_path: "",
#   shallow_prefix: "",
#   do: [
#     {resources: :users},
#     ...
#   ]
# }

def resource_config(route, parent=false)
  if parent && parent.present?
    controller = 'nested_active_api'
    route[:parent_resource] = parent.to_s.classify
  else
    controller = 'active_api'
  end

  if route[:resources] && route[:resources].present?
    model = route[:resources].to_s.classify
  end

  if route[:model] && route[:model].present?
    model = route[:model]
  end

  {
    constraints: {format: 'json'},
    except: [:new, :edit],
    controller: controller,
    model: model
  }.merge(route)
end

def resource_name(route)
  route[:resources].to_sym
end

routes = ActiveApi::Engine.config.try(:route_config)

unless routes
  warn "You haven't configured any routes for ActiveApi. run `rails g active_api:install`"
end

ActiveApi::Engine.config.route_config = routes || []

ActiveApi::Engine.routes.draw do
  ActiveApi::Engine.config.route_config.each do |route|

    name = resource_name(route)
    nested = route.delete(:do)
    config = resource_config(route)

    if !nested
      resources name, config
    else

      resources name, config do
        nested.each do |nested|
          if nested[:do].present?
            raise "Cannot nest apis this deep"
          end
          nested_name = resource_name(nested)
          nested_config = resource_config(nested, name)
          resources nested_name, nested_config
        end
      end

    end

  end

  root to: 'application#root'
  if ActiveApi::Engine.config.try(:documentation)
    mount GrapeSwaggerRails::Engine => '/api-documentation'
  end
end
