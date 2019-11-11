class Track < ApplicationRecord
  def ==(other)
    return artist_name == other.artist_name && name == other.name
  end
end