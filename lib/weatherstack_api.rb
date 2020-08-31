class WeatherstackApi
  def self.weather_in(location)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(location)}"

    return nil if response.key?('success') && response['success'] == false

    # Return only the weather part of the response but also include name
    # Other data would contain coordinates etc.
    weather = response['current']
    weather['name'] = response['location']['name']
    # Convert wind speed from km/h to m/s
    weather['wind_speed'] = (weather['wind_speed'].to_d / 3.6).round(1)
    weather
  end

  def self.key
    # Raises KeyError if key not found
    Rails.application.credentials.weatherstack_apikey!
  end
end
