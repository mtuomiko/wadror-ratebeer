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

    # ratings.max_by(&:score).beer
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    scores_and_styles = ratings.map { |r| { score: r.score, style: r.beer.style } }
    grouped_by_style = scores_and_styles.group_by { |i| i[:style] }
    trimmed = grouped_by_style.transform_values { |v| v.map { |inner_hash| inner_hash[:score] } }
    averages = trimmed.transform_values { |v| array_average(v) }
    # max_by of hash returns array so we access the style name from the first element
    averages.max_by { |_k, v| v }[0]
  end

  def favorite_brewery
    return nil if ratings.empty?

    scores_and_breweries = ratings.map { |r| { score: r.score, brewery: r.beer.brewery } }
    grouped_by_brewery = scores_and_breweries.group_by { |i| i[:brewery] }
    trimmed = grouped_by_brewery.transform_values { |v| v.map { |inner_hash| inner_hash[:score] } }
    averages = trimmed.transform_values { |b| array_average(b) }
    # max_by of hash returns array so we access the style name from the first element
    averages.max_by { |_k, v| v }[0]
  end

  def array_average(array)
    total = array.inject(0) { |sum, e| sum + e }
    total / array.length.to_f
  end
end
