class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherstackApi.weather_in(params[:city])
    # Convert km/h to m/s
    if @weather
      @weather['wind_speed'] = (@weather['wind_speed'].to_d / 3.6).round(1)
    end

    if @places.empty?
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
