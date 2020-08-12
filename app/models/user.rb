class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
  validate :password_must_contain_upper_case

  def password_must_contain_upper_case_and_number
    return if /^(?=.*[A-Z])(?=.*[0-9]).*$/ =~ password

    errors.add(:password, 'must contain at least one upper case letter and one number')
  end
end