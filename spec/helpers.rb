module Helpers
  def sign_in(credentials)
    visit signin_path
    fill_in('username', with: credentials[:username])
    fill_in('password', with: credentials[:password])
    click_button('Log in')
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
end
