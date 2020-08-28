module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    avg = ratings.average(:score)
    return nil if avg.nil?

    # avg.round(1)
    avg
  end
end
