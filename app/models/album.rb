class Album < ApplicationRecord
  has_many :artists

  serialize :genres, Array
end