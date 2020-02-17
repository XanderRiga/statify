class Track < ApplicationRecord
  has_one :album
  has_many :artists
end