require 'rails/generators/base'

module ActiveApi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates an ActiveApi initializer and mounts the api in your routes."

      def copy_initializer
        template "active_api.rb", "config/initializers/active_api.rb"
      end

      def route_me
        route "mount ActiveApi::Engine => '/active_api'"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
