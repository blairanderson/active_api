# requires all dependencies
Gem.loaded_specs['active_api'].dependencies.each do |d|
  require d.name
end

module ActiveApi
  class Engine < ::Rails::Engine
    isolate_namespace ActiveApi
  end
end
