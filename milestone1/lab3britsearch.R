# Import and attach libraries/packages

pkgs <- c("Rspotify", "spotifyr", "httpuv", "ggridges", "highcharter", "knitr", 
          "tm", "tidyverse", "igraph", "ggplot2", "stringr", "scales")
#install.packages(pkgs)
lapply(pkgs, library, character.only = TRUE)

library(devtools)
#install_github("tiagomendesdantas/Rspotify")
#install_github("charlie86/spotifyr")
library(Rspotify)
library(spotifyr)
# Configure Application to Store Spotify Authentication Data

options(httr_oauth_cache = TRUE)


# Set up authentication variables

app_id <- "6650d1093e9047679cb415f83714c8ab"
app_secret <- "becf2a78579e4f158c0d406277b4e478"
token <- "1"


# Perform Authentication (for both spotify libraries)

keys <- spotifyOAuth(token, app_id, app_secret)

Sys.setenv(SPOTIFY_CLIENT_ID = app_id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = app_secret)
access_token <- get_spotify_access_token()


# Get John Mayer Data (using keyword)

keyword <- "Britney+Spears"
findArtist <- searchArtist(keyword, token=keys)
#View(findArtist)


# Retrieve Information About Artist

john_mayer <- getArtistinfo('0hEurMDQu99nJRq8pTxO14',token = keys)


# Retrieve Album and Song Data of Artist

albums <- getAlbums('0hEurMDQu99nJRq8pTxO14', token=keys)
#View(albums)
songs <- getAlbum('0jZFu2tihRJ65iYAo0oOtP', token=keys)
#View(songs)


# Retrieve Song Data

song <- getFeatures('1LM6t24SjQr2bJHqeGIR4U', token=keys)
#View(song)

# Get Backstreet Boys Feature Data

backstreetBoys <- get_artist_audio_features('Britney spear')
#view(backstreetBoys)


# Get Happiest Songs from the Backstreet Boys (If the '-' symbol does not preceed valence, we sort tracks in ascending rather than descending order)

backstreetBoys %>%
  arrange(-valence) %>%
  select(track_name, artist_name, valence) %>%
  head(10) %>%
  kable()


# Plot Valence Scores for Every Album
ggplot(backstreetBoys, aes(x = valence, y= album_name)) +
  geom_density_ridges() +
  theme_ridges() +
  ggtitle("Plot of Backstreet Boys' Joy Distributions",
          subtitle = "Based on valence from Spotify's Web API")


# Get Taylor Swift Relationship Data

related <- getRelated('taylor swift', token=keys)
#view(related)
topsongs <- getPlaylistSongs("spotify", "4hOKQuZbraPDIfaGbM3lKI", token=keys)


# Construct Edges

edges <- c()
for (artist in topsongs$artist){
  related <- getRelated(artist, token=keys)
  for (relatedartist in related$name){
    edges <- append(edges, artist)
    edges <- append(edges, relatedartist)
  }
}


# Create Graph and Save to External File

g1 <- graph(edges)
write.graph(g1, "g1.graphml", format="graphml")

