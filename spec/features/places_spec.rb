require 'rails_helper'

describe 'Places' do
  before :each do
    canned_answer = <<~END_OF_STRING
      {"success":false,"error":{"code":615,"type":"request_failed","info":"Your API request failed. Please try again or contact support."}}
    END_OF_STRING

    stub_request(:get, /.*weatherstack.com*/).to_return(body: canned_answer, headers: { 'Content-Type' => 'application/json' })
  end

  it 'if one is returned by the API, it is shown at the page' do
    allow(BeermappingApi).to receive(:places_in).with('kumpula').and_return(
      [Place.new(name: 'Oljenkorsi', id: 1)]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button 'Search'

    expect(page).to have_content 'Oljenkorsi'
  end

  it 'if multiple places are returned, all are shown on the page' do
    allow(BeermappingApi).to receive(:places_in).with('Someplace').and_return(
      [
        Place.new(name: 'Beerery', id: 1),
        Place.new(name: 'Drinkery', id: 2),
        Place.new(name: 'Hangovery', id: 3),
      ]
    )

    visit places_path
    fill_in('city', with: 'Someplace')
    click_button 'Search'

    expect(page).to have_content 'Beerery'
    expect(page).to have_content 'Drinkery'
    expect(page).to have_content 'Hangovery'
  end

  it 'if no places are found, the notification is displayed' do
    allow(BeermappingApi).to receive(:places_in).with('Noplace').and_return([])
    visit places_path
    fill_in('city', with: 'Noplace')
    click_button 'Search'

    expect(page).to have_content 'No locations in Noplace'
  end
end
