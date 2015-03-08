require_dependency "active_api/application_controller"

module ActiveApi
  class TopLevelsController < ApplicationController
    before_action do
      @model = params[:model].capitalize.constantize
      unless @model.exists?
        not_found
      end
    end

    before_action only: [:show, :update, :destroy] do
      @model_instance = @model.find(params[:id])
    end

    def index
      render json: @model.all, root: params[:model]+'s'
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
  end
end
