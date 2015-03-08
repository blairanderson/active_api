module ActiveApi
  module ApplicationHelper
    def swagger_discovery_url
      Rails.root+"/swagger.json"
    end
  end
end
