require 'rails_helper'

RSpec.describe Beer, type: :model do
  it 'is saved when it has name, style and brewery' do
    brewery = Brewery.new name: 'test', year: 2000
    beer = Beer.create name: 'Nelonen', style: 'asdf', brewery: brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it 'is not saved when is has no name' do
    brewery = Brewery.new name: 'test', year: 2000
    beer = Beer.create style: 'asdf', brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it 'is not saved when is has no style (:D)' do
    brewery = Brewery.new name: 'test', year: 2000
    beer = Beer.create name: 'Nelonen', brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
