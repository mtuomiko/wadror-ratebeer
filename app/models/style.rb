class Style < ApplicationRecord
  include RatingAverage
  extend TopObjects

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers
end
