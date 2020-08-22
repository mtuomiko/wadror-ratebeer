class WeatherstackApi
  def self.weather_in(location)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(location)}"

    return nil if response.key?('success') && response['success'] == false

    # Return only the weather part of the response but also include name
    # Other data would contain coordinates etc.
    weather = response['current']
    weather['name'] = response['location']['name']
    weather
  end

  def self.key
    raise 'WEATHERSTACK_APIKEY env variable not defined' if ENV['WEATHERSTACK_APIKEY'].nil?

    ENV['WEATHERSTACK_APIKEY']
  end
end
