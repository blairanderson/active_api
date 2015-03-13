module ActiveApi
  module SharedActiveApiFindersAndSetters

    def model_params
      params.require(params[:model].to_sym).permit!
    end

    def get_serializer_for(klass)
      if params[:serializer].present?
        serializer_class_name = "#{params[:serializer]}Serializer"
      else
        serializer_class_name = "#{klass.name}Serializer"
      end
      serializer_class = serializer_class_name.safe_constantize

      if serializer_class
        serializer_class
      elsif klass.superclass
        get_serializer_for(klass.superclass)
      end
    end

    def set_model
      @model = params[:model].safe_constantize
      unless @model.exists?
        not_found
      end

      if @current_user
        @model = @model.where(user_id: @current_user.id)
      end
    end

    def set_serializer
      @serializer = get_serializer_for(@model)
    end

    def set_scopes_and_filters
      if @serializer
        # https://keen.io/docs/api/reference/

        @model = @serializer.apply_scopes(@model, params)
        # @model = @serializer.apply_order(@model)
        # @model = @serializer.apply_filter(@model)
        @model = @serializer.apply_property_names(@model, params)
      end
    end

    def set_pagination
      if @serializer
        per_page = @serializer.per_page
      else
        per_page = 50
      end
      require "will_paginate"
      @model = @model.paginate(page: params[:page], per_page: per_page)
    end

  end
end
