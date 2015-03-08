module ActiveApi

  class ApplicationController < ActionController::Base

    def root
      root = request.path[0..-2]
      all_routes = ActiveApi::Engine.routes.routes.map do |route|
         root + route.path.spec.to_s
      end

      render json: {
          yolo: true,
          routes: all_routes
        }
    end

  end

end
