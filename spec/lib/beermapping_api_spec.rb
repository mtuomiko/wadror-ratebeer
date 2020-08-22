require 'rails_helper'

describe 'BeermappingApi' do
  describe 'in case of cache miss' do
    before :each do
      Rails.cache.clear
    end

    it 'When HTTP GET returns one entry, it is parsed and returned' do
      canned_answer = <<~END_OF_STRING
        [{"id":18856,"name":"Panimoravintola Koulu","status":"Brewpub","reviewlink":"https:\/\/beermapping.com\/location\/18856","proxylink":"http:\/\/beermapping.com\/maps\/proxymaps.php?locid=18856&amp;d=5","blogmap":"http:\/\/beermapping.com\/maps\/blogproxy.php?locid=18856&amp;d=1&amp;type=norm","street":"Eerikinkatu 18","city":"Turku","state":"","zip":"20100","country":"Finland","phone":"(02) 274 5757","url":"panimoravintolakoulu.fi\/","overall":"0","imagecount":"0"}]
      END_OF_STRING

      stub_request(:get, /.*turku*/).to_return(body: canned_answer, headers: { 'Content-Type' => 'application/json' })

      places = BeermappingApi.places_in('turku')

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  end

  describe 'in case of cache hit' do
    before :each do
      Rails.cache.clear
    end

    it 'When one entry in cache, it is returned' do
      canned_answer = <<~END_OF_STRING
        [{"id":18856,"name":"Panimoravintola Koulu","status":"Brewpub","reviewlink":"https:\/\/beermapping.com\/location\/18856","proxylink":"http:\/\/beermapping.com\/maps\/proxymaps.php?locid=18856&amp;d=5","blogmap":"http:\/\/beermapping.com\/maps\/blogproxy.php?locid=18856&amp;d=1&amp;type=norm","street":"Eerikinkatu 18","city":"Turku","state":"","zip":"20100","country":"Finland","phone":"(02) 274 5757","url":"panimoravintolakoulu.fi\/","overall":"0","imagecount":"0"}]
      END_OF_STRING

      stub_request(:get, /.*turku*/).to_return(body: canned_answer, headers: { 'Content-Type' => 'application/json' })

      BeermappingApi.places_in('turku')
      places = BeermappingApi.places_in('turku')

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  end

  it 'When HTTP GET returns no entries, empty array is returned' do
    canned_answer = <<~END_OF_STRING
      [{"id":null,"name":null,"status":null,"reviewlink":null,"proxylink":null,"blogmap":null,"street":null,"city":null,"state":null,"zip":null,"country":null,"phone":null,"url":null,"overall":null,"imagecount":null}]
    END_OF_STRING

    stub_request(:get, /.*emptytown*/).to_return(body: canned_answer, headers: { 'Content-Type' => 'application/json' })

    places = BeermappingApi.places_in('emptytown')
    expect(places.size).to eq(0)
  end

  it 'When HTTP GET returns multiple entries, all are returned as an array of Places' do
    canned_answer = <<~END_OF_STRING
      [{"id":21528,"name":"Maistila","status":"Brewery","reviewlink":"https:\/\/beermapping.com\/location\/21528","proxylink":"http:\/\/beermapping.com\/maps\/proxymaps.php?locid=21528&amp;d=5","blogmap":"http:\/\/beermapping.com\/maps\/blogproxy.php?locid=21528&amp;d=1&amp;type=norm","street":"Kaarnatie 20","city":"Oulu","state":"Oulun Laani","zip":"90530","country":"Finland","phone":"044 291 9589","url":"http:\/\/maistila.fi","overall":"0","imagecount":"0"},{"id":21547,"name":"Sonnisaari","status":"Brewery","reviewlink":"https:\/\/beermapping.com\/location\/21547","proxylink":"http:\/\/beermapping.com\/maps\/proxymaps.php?locid=21547&amp;d=5","blogmap":"http:\/\/beermapping.com\/maps\/blogproxy.php?locid=21547&amp;d=1&amp;type=norm","street":"Tuotekuja 1","city":"Oulu","state":"Oulun Laani","zip":"90410","country":"Finland","phone":"","url":"http:\/\/www.sonnisaari.com","overall":"0","imagecount":"0"}]
    END_OF_STRING

    stub_request(:get, /.*oulu*/).to_return(body: canned_answer, headers: { 'Content-Type' => 'application/json' })

    places = BeermappingApi.places_in('Oulu')
    first_place = places.first
    second_place = places.last

    expect(places.size).to eq(2)
    expect(first_place.is_a?(Place)).to eq(true)
    expect(second_place.is_a?(Place)).to eq(true)
    expect(first_place.name).to eq('Maistila')
    expect(second_place.name).to eq('Sonnisaari')
  end
end
