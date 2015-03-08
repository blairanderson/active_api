require_dependency "active_api/application_controller"

module ActiveApi
  class ActiveApiController < ApplicationController
    before_action do
      set_model
      set_serializer
    end

    before_action only: [:show, :update, :destroy] do
      @model_instance = @model.find(params[:id])
      @root = params[:model].downcase
    end

    def index
      set_scopes_and_filters
      set_pagination
      root = params[:model].downcase+'s'
      render json: @model, meta: {
          total_pages: @model.total_pages,
          page: (params[:page] || 1).to_i
        }, root: root
    end

    def create
      @model_instance = @model.new(model_params)

      if @model_instance.save
        render json: @model_instance, root: @root
      else
        render json: {errors: @model_instance.errors}, status: :unprocessable_entity
      end
    end

    def show
      render json: @model_instance
    end

    def update
      if @model_instance.update(model_params)
        render json: @model_instance, root: @root
      else
        render json: {errors: @model_instance.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      @model_instance.destroy
      render json: @model_instance, root: @root
    end

    private
    # Only allow a trusted parameter "white list" through.
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
