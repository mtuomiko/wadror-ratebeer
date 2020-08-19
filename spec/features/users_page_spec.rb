require 'rails_helper'

describe 'User' do
  include Helpers

  before :each do
    FactoryBot.create :user
  end

  describe 'who has signed up' do
    it 'can signin with right credentials' do
      sign_in(username: 'Pekka', password: 'Foobar1')

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it 'is redirected back to signin form if wrong credentials given' do
      sign_in(username: 'Pekka', password: 'wrong')

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username or password failure'
    end
  end

  it 'when signed up with good credentials, is added to the system' do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect{
      click_button('Create User')
    }.to change{ User.count }.by(1)
  end

  describe 'page' do
    let!(:user2) { FactoryBot.create :user, username: 'user2', password: 'SecretPass1', password_confirmation: 'SecretPass1' }
    let!(:user3) { FactoryBot.create :user, username: 'user3', password: 'SecretPass2', password_confirmation: 'SecretPass2' }
    let!(:brewery1) { FactoryBot.create :brewery, name: 'Koff' }
    let!(:beer1) { FactoryBot.create :beer, name: 'Bisse', brewery: brewery1 }
    let!(:rating1) { FactoryBot.create :rating, beer: beer1, score: 22, user: user2 }
    let!(:rating2) { FactoryBot.create :rating, beer: beer1, score: 33, user: user2 }
    let!(:rating3) { FactoryBot.create :rating, beer: beer1, score: 44, user: user3 }

    it 'ratings display only ratings made by the user' do
      visit user_path(user2)
      expect(page).to have_content 'Bisse 22'
      expect(page).to have_content 'Bisse 33'
      expect(page).not_to have_content 'Bisse 44'
    end

    it 'ratings no longer contain rating after user clicks delete link' do
      Capybara.current_driver = :windows_chrome
      sign_in(username: 'user2', password: 'SecretPass1')

      accept_confirm do
        page.first('li', text: 'Bisse 33').first('a').click
      end

      expect(page).to have_content 'Bisse 22'
      expect(page).not_to have_content 'Bisse 33'
      Capybara.use_default_driver
    end

    it 'displays favorite beer style and brewery' do
      visit user_path(user2)

      expect(page).to have_content 'Lager'
      expect(page).to have_content 'Koff'
    end
  end
end
