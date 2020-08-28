module TopObjects
  extend ActiveSupport::Concern

  def top(num)
    sorted_by_rating_desc = all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_desc[0..(num - 1)]
  end
end
