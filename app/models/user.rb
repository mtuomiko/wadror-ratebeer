class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }
  validate :password_must_contain_upper_case_and_number

  def password_must_contain_upper_case_and_number
    return if /^(?=.*[A-Z])(?=.*[0-9]).*$/ =~ password

    errors.add(:password, 'must contain at least one upper case letter and one number')
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(grouped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by { |r| r.beer.send(grouped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group: group, score: average_of(ratings) }
    end

    averages.max_by { |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def self.top(num)
    sorted_by_rating_count_desc = User.all.sort_by{ |u| -(u.ratings.count || 0) }
    sorted_by_rating_count_desc[0..(num - 1)]
  end
end
