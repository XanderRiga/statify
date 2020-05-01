class Track < ApplicationRecord
  has_one :album
  has_many :artists

  has_many :hears
end