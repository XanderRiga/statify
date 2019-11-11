# frozen_string_literal: true

require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'],
           scope: 'user-read-recently-played user-top-read user-read-playback-state user-read-currently-playing user-modify-playback-state playlist-modify-public user-library-read user-library-modify playlist-read-collaborative app-remote-control'
end
