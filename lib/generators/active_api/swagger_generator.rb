require 'rails/generators/base'
require 'action_dispatch/routing/inspector'

module ActionDispatch
  module Routing
    # https://github.com/rails/docrails/blob/master/actionpack/lib/action_dispatch/routing/inspector.rb
    class EngineRoutesInspector < RoutesInspector
      def get_routes(routes)
        routes.collect do |route|
          RouteWrapper.new(route)
        end.reject(&:internal?)
      end

      def format(formatter)
        routes = get_routes(@routes)
        formatter.to_swagger_v1(routes)
        # formatter.to_swagger_v2(routes)
        formatter.result
      end
    end

    class SwaggerFormatter
      attr_reader :result

      def initialize
        @result = {}
      end

      # eventually should look like this: https://github.com/swagger-api/swagger-spec/blob/master/versions/1.2.md
      def to_swagger_v1(routes)
        names = {}
        @result = routes.each_with_object({}) do |route, result|
          result[route.path] ||= {operations: []}

          if route.name.present?
            names[route.path] = route.name
          end

          result[route.path][:description] = "#{route.verb} : #{names[route.path]}"

          result[route.path][:operations] << {
            method: route.verb,
            summary: names[route.path],
            notes: route.defaults.to_s,
            nickname: names[route.path],
            parameters: [
              {
                name: "body",
                description: "param description.",
                required: true,
                type: route.defaults[:model],
                paramType: "body"
              }
            ]
          }
        end
        @result.delete("/")
        @result.delete("/api-documentation")
        @result = @result.map do |path, api|
          api[:path] = path
          api
        end
      end

      # eventually should look like this: https://github.com/swagger-api/swagger-spec/blob/master/versions/2.0.md#pathsObject
      # {
      #   path: {
      #     verb: {
      #       description: "Returns all pets from the system that the user has access to",
      #     }
      #   }
      # }
      def to_swagger_v2(routes)
        names = {}
        @result = routes.each_with_object({}) do |route, result|
          result[route.path] ||= {}
          if route.name.present?
            names[route.path] = route.name
          end

          result[route.path][route.verb] = {
            name: names[route.path],
            tags: route.defaults.slice(:resources, :parent_resource).values,
            summary: route.defaults[:model],
            description: route.defaults.to_s,
          }
        end
        @result.delete("/")
        @result.delete("/api-documentation")
      end
    end
  end
end

module ActiveApi
  module Generators
    class SwaggerGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Swagger.json from ActiveApi config."

      def copy_initializer
        template "swagger.json", "public/swagger.json"
      end

      private

      def defined_apis
        all_routes = ActiveApi::Engine.routes.routes
        inspector = ActionDispatch::Routing::EngineRoutesInspector.new(all_routes)
        inspector.format(ActionDispatch::Routing::SwaggerFormatter.new)
      end

      def mount_path
        Rails.application.routes.named_routes[:active_api].path.spec.to_s
      end

      def swagger_api_config
        ActiveApi::Engine.config.documentation
      end
    end
  end
end
