class Membership < ApplicationRecord
  belongs_to :beer_club
  belongs_to :user

  validates_uniqueness_of :beer_club, scope: :user
end
