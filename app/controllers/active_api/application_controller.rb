module ActiveApi

  class ApplicationController < ActionController::Base
    before_filter do # restrict access
      auth = ActiveApi.auth

      key_holder_class = auth[:model].safe_constantize
      key_holder_class ||= ApiKey
      if request.headers["Authorization"] && key_holder_class.exists?
        user = authenticate_with_http_token do |t, o|
          if auth[:model] == "User"
            query = {}
            query[auth[:token]]=t
            User.where(query).first
          else
            key_holder_class.where(token: t).first.try(auth[:user])
          end
        end

        if user
          @current_user = user
        else
          head :unauthorized
        end
      else
        @current_user = false
      end
    end


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

    private
    def not_found
      raise 'boom'
    end
  end

end
