require 'rails_helper'

RSpec.describe Style, type: :model do
  it 'is saved when it has name' do
    style = Style.create name: 'IPAisa'

    expect(style).to be_valid
    expect(Style.count).to eq(1)
  end

  it 'is saved when it has a name and description' do
    style = Style.create name: 'IPAisa', description: 'Bitter'

    expect(style).to be_valid
    expect(Style.count).to eq(1)
  end
end
