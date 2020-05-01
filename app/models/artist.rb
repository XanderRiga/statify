class Artist < ApplicationRecord
  serialize :genres, Array

  has_and_belongs_to_many :tracks
  has_and_belongs_to_many :albums
end