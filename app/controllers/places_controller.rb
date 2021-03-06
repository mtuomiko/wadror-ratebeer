class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherstackApi.weather_in(params[:city])

    if @places.nil?
      redirect_to places_path
    elsif @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = params[:city]
      render :index
    end
  end

  def show
    @place = BeermappingApi.place_with_id(session[:city], params[:id])

    redirect_to places_path, notice: "No locations found for id #{params[:id]}" unless @place
  end
end
