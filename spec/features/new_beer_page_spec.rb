require 'rails_helper'

describe "New beer" do
  include Helpers

  let!(:brewery) { FactoryBot.create :brewery, name: 'TestBrew' }
  let!(:style) { FactoryBot.create :style }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it 'is created when a valid name is given on new beer page' do
    visit new_beer_path

    fill_in('beer_name', with: 'Rauchbier')

    expect{
      click_button 'Create Beer'
    }.to change{ Beer.count }.from(0).to(1)
  end

  it 'is not created and error is displayed when empty name is given on new beer page' do
    visit new_beer_path

    click_button 'Create Beer'

    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
