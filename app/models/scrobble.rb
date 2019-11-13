class Scrobble < ApplicationRecord
  serialize :artist_ids, Array
end