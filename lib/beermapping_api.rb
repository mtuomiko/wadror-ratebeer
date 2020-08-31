class BeermappingApi
  def self.places_in(city)
    return if city.blank?

    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}&s=json"
    # Not used anymore since API has updated
    # places = response.parsed_response["bmp_locations"]["location"]

    return [] if response.first.is_a?(Hash) && response.first['id'].nil?

    response.map do |place|
      Place.new(place)
    end
  end

  def self.place_with_id(city, ident)
    # If queried city exists, try from cache
    if city
      city = city.downcase
      places = Rails.cache.read(city)
      result = places.find{ |p| p.id.to_s == ident }

      if result && !result['id'].nil?
        return Place.new(result)
      end
    end

    url = "http://beermapping.com/webservice/locquery/#{key}/"
    response = HTTParty.get "#{url}#{ident}&s=json"

    return nil if response.first.is_a?(Hash) && response.first['id'] == 0

    result = response.find{ |p| p['id'].to_s == ident }
    Place.new(result)
  end

  def self.key
    # Raises KeyError if key not found
    Rails.application.credentials.beermapping_apikey!
  end
end
