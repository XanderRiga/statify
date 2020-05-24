class Hear < ApplicationRecord
  belongs_to :track

  scope :in_date_range, ->(start_date, end_date) { where(created_at: start_date.to_date.beginning_of_day..end_date.to_date.end_of_day) }
end