require_dependency "active_api/application_controller"

module ActiveApi
  class TopLevelsController < ApplicationController
    before_action do
      @model = params[:model].safe_constantize
      unless @model.exists?
        not_found
      end
      @serializer = get_serializer_for(@model)
    end

    before_action only: [:show, :update, :destroy] do
      @model_instance = @model.find(params[:id])
    end

    def index
      if @serializer
        per_page = @serializer.per_page
        scoped = @serializer.apply_scopes(@model, params)
      else
        per_page = 50
        scoped = @model
      end

      # https://keen.io/docs/api/reference/

      # scoped = apply_order(scoped)
      # scoped = apply_filter(scoped)
      # scoped = apply_property_names(scoped)

      require "will_paginate"
      paginated = scoped.paginate(page: params[:page], per_page: per_page)

      render json: paginated, meta: {
          total_pages: paginated.total_pages,
          page: (params[:page] || 1).to_i
        }, root: params[:model]+'s'

    end

    def create
      @model_instance = @model.new(model_params)

      if @model_instance.save
        render json: @model_instance, root: params[:model]
      else
        render json: {errors: @model_instance.errors}, status: :unprocessable_entity
      end
    end

    def show
      render json: @model_instance
    end

    def update
      if @model_instance.update(model_params)
        render json: @model_instance, root: params[:model]
      else
        render json: {errors: @model_instance.errors}, status: :unprocessable_entity
      end
    end

    def destroy
      @model_instance.destroy
      render json: @model_instance, root: params[:model]
    end

    private
    # Only allow a trusted parameter "white list" through.
    def model_params
      params.require(params[:model].to_sym).permit!
    end


    def get_serializer_for(klass)
      serializer_class_name = "#{klass.name}Serializer"
      serializer_class = serializer_class_name.safe_constantize

      if serializer_class
        serializer_class
      elsif klass.superclass
        get_serializer_for(klass.superclass)
      end
    end

  end
end
