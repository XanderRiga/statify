# Statify
This is a hacky project to attempt to visualize more of a user's Spotify data. 
It is inspired by Spotify's year in review.

## What it does

This project asks a user to login to Spotify after creating an account on the site. 
Once the user does that it tracks every song that user listens to from that moment forward. 
A user is also able to upload data that they request from Spotify directly to the site so they can get more detailed data immediately.

## Limitations

The spotify API is not as full-featured as [one might think](https://developer.spotify.com/documentation/web-api/reference/).
It has some cool data, but it has some serious gaps where data starts to become unreliable or it makes it difficult to create any truly powerful visualization.
For instance, the [tracks](https://developer.spotify.com/documentation/web-api/reference/tracks/get-track/) don't contain any sort of genre, so being able to visualize by genre becomes nearly impossible or at best guesswork based on artists.