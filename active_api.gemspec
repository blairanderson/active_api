$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_api"
  s.version     = ActiveApi::VERSION
  s.authors     = ["Blair Anderson"]
  s.email       = ["blair@repairshopr.com"]
  s.homepage    = "https://github.com/blairanderson/active_api"
  s.summary     = "Helps bootstrap your api."
  s.description = "ActiveApi."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
  s.add_runtime_dependency "active_model_serializers"
  s.add_runtime_dependency "will_paginate"
  s.add_runtime_dependency "grape-swagger-rails"

  s.add_dependency "rails", "~> 4.2.0"
end
