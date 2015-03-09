# requires all dependencies
Gem.loaded_specs['active_api'].dependencies.each do |d|
  require d.name
end

module ActiveApi
  class Engine < ::Rails::Engine

    isolate_namespace ActiveApi

    config.generators do |g|
      g.test_framework      :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
