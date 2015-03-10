$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_api"
  s.version     = ActiveApi::VERSION
  s.authors     = ["Blair Anderson"]
  s.email       = ["blair81@gmail.com.com"]
  s.homepage    = "https://github.com/blairanderson/active_api"
  s.summary     = "ActiveApi helps bootstrap your API."
  s.description = "ActiveApi brings convention over configuration to help you provide a smart JSON API and documentation."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
  s.add_runtime_dependency "active_model_serializers"
  s.add_runtime_dependency "will_paginate"
  s.add_runtime_dependency "grape-swagger-rails"
  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "byebug"
  # s.add_development_dependency "sqlite3"
  # s.add_development_dependency "capybara"
end
