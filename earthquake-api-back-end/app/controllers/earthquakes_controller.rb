class EarthquakesController < ApplicationController
    def show
      @earthquake = Earthquake.find(params[:id])
      render json: @earthquake
    end
  
    def index
      @earthquakes = Earthquake.all
      render json: @earthquakes
    end
  
    private
  
    def earthquake_params
      params.require(:earthquake).permit(:name, :description, :price, :stock)
    end
  end