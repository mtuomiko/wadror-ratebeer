class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    #total = ratings.reduce(0) { |sum, r| sum + r.score }
    #puts total
    #average = total.to_f / ratings.count
    #average.round(2)

    ratings.average(:score).round(2)
  end
end
