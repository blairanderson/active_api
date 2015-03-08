require 'active_model_serializers'
module ActiveModel
  class Definition < Serializer
    def self.has_scope(scope, options)
      @_has_scopes
    end
  end
end
