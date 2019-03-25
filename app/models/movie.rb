class Movie < ActiveRecord::Base
  def self.all_ratings
    uniq.pluck(:rating)
  end
end
