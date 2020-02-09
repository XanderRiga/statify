class Artist < ApplicationRecord
  serialize :genres, Array
end