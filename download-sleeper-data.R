########################################
### Download Sleeper Data

# TODO:
# - Seperate script for functions?
# - Team metadata function, storing settings and metadata from rosters pull
########################################

# Load packages ----------------------------------------------------------------
library(tidyverse)
library(httr2)
library(jsonlite)

# User information -------------------------------------------------------------
config <- config::get()

# Define download functions ----------------------------------------------------

# Download league data
download_roster_data <- function(request){
  # Request
  req <- request(request)
  
  # Perform request
  resp <- req_perform(req)
  
  # Create dataframe
  data <- resp |> resp_body_json()
  df <- do.call(rbind, data) |> as.data.frame()
  
  # Drop unused data and reorganize columns
  df <- df %>%
    select(owner_id, roster_id, players, -co_owners, -keepers, -league_id, -metadata, -player_map, -taxi, -reserve, -settings, -starters)
  
  # Expand players
  df <- df %>%
    unnest(players)
  
  # Return data frame
  return(df)
}

download_starters_data <- function(request){
  # Request
  req <- request(request)
  
  # Perform request
  resp <- req_perform(req)
  
  # Create dataframe
  data <- resp |> resp_body_json()
  df <- do.call(rbind, data) |> as.data.frame()
  
  # Drop unused data and reorganize columns
  df <- df %>%
    select(owner_id, roster_id, starters, -co_owners, -keepers, -league_id, -metadata, -player_map, -taxi, -reserve, -settings, -players)
  
  # Expand players
  df <- df %>%
    unnest(starters)
  
  # Return data frame
  return(df)
}

# Download player data
download_player_data <- function(request){
  # Request
  req <- request(request)
  
  # Perform request
  resp <- req_perform(req)
  
  # Create dataframe
  data <- resp |> resp_body_json()
  df <- do.call(rbind, data)
  
  # Remove index
  df <- cbind(sleeper_id = rownames(df), df)
  rownames(df) <- NULL
  
  # Return data frame
  return(df)
}


# Download data ----------------------------------------------------------------
rosters_call <- paste0("https://api.sleeper.app/v1/league/", config$sleeper_league_id, "/rosters")
rosters <- download_roster_data(rosters_call)

starters_call <- paste0("https://api.sleeper.app/v1/league/", config$sleeper_league_id, "/rosters")
starters <- download_roster_data(starters_call)

player_call <- "https://api.sleeper.app/v1/players/nfl"
players <- download_player_data(player_call)
