class Hear < ApplicationRecord
  has_one :track, required: true
end