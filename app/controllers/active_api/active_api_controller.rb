require_dependency "active_api/application_controller"

module ActiveApi
  class ActiveApiController < ApplicationController
    include SharedActiveApiFindersAndSetters

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

      root = params[:model].tableize

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
  end
end
