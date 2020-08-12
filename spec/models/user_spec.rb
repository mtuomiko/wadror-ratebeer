require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has the username set correctly' do
    user = User.new username: 'Pekka'

    expect(user.username).to eq('Pekka')
  end

  it 'is not saved without a password' do
    user = User.create username: 'Pekka'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe 'with a proper password' do
    let(:user){ FactoryBot.create(:user) }

    it 'is saved' do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it 'and with two ratings, has the correct average rating' do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it 'with a too short password is not saved' do
    user = User.create username: 'Pekka', password: 'pas', password_confirmation: 'pas'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'with a password without numbers is not saved' do
    user = User.create username: 'Pekka', password: 'PASSword', password_confirmation: 'PASSword'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'with a password without upper case letters is not saved' do
    user = User.create username: 'Pekka', password: 'password22', password_confirmation: 'password22'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe 'favorite beer' do
    let(:user){ FactoryBot.create(:user) }

    it 'has method for determining one' do
      expect(user).to respond_to(:favorite_beer)
    end

    it 'without ratings does not have one' do
      expect(user.favorite_beer).to eq(nil)
    end

    it 'is the only rated if only one rating' do
      beer = FactoryBot.create(:beer)
      FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it 'is the one with highest rating if several rated' do
      create_beers_with_many_ratings({ user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({ user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe 'favorite style' do
    let(:user){ FactoryBot.create(:user) }

    it 'has method for determining one' do
      expect(user).to respond_to(:favorite_style)
    end

    it 'without ratings does not have one' do
      expect(user.favorite_beer).to eq(nil)
    end

    it 'is the style of the only rating (if only one rating)' do
      beer = FactoryBot.create(:beer, style: 'TestStyle')
      FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq('TestStyle')
    end

    it 'is the style with highest average rating if several styles rated' do
      create_beers_with_many_ratings({ user: user, style: 'TestIPA' }, 9, 2, 5, 7, 14)
      create_beers_with_many_ratings({ user: user, style: 'WinnerWinner' }, 30, 20)

      expect(user.favorite_style).to eq('WinnerWinner')
    end
  end

  describe 'favorite brewery' do
    let(:user){ FactoryBot.create(:user) }

    it 'has method for determining one' do
      expect(user).to respond_to(:favorite_brewery)
    end

    it 'without ratings does not have one' do
      expect(user.favorite_brewery).to eq(nil)
    end

    it 'is the brewery which makes the beer of the only rating' do
      brewery = FactoryBot.create(:brewery, name: 'TestBrewing')
      beer = FactoryBot.create(:beer, brewery: brewery)
      FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it 'is the brewery with the highest average rating if ratings exist for multiple breweries' do
      bad_brewery = FactoryBot.create(:brewery, name: 'BadBrewing')
      good_brewery = FactoryBot.create(:brewery, name: 'GoodBrewing')

      create_beers_with_many_ratings({ user: user, brewery: bad_brewery }, 5, 2, 5, 3, 12)
      create_beers_with_many_ratings({ user: user, brewery: good_brewery }, 15, 44, 38, 49, 50)

      expect(user.favorite_brewery).to eq(good_brewery)
    end
  end
end

# object must contain user and can contain either style or brewery
def create_beer_with_rating(object, score)
  beer = if object[:style]
           FactoryBot.create(:beer, style: object[:style])
         elsif object[:brewery]
           FactoryBot.create(:beer, brewery: object[:brewery])
         else
           FactoryBot.create(:beer)
         end

  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

# Create multiple beers with scores as a variable-length argument list
def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end
