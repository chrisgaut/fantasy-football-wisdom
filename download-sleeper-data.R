########################################
### Download Sleeper Data

# TODO:
# - Seperate script for functions?
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
  
  # Drop unused data
  df <- df %>%
    select(-co_owners, -keepers, -league_id, -metadata, -player_map, -taxi)
  
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

player_call <- "https://api.sleeper.app/v1/players/nfl"
players <- download_player_data(player_call)
