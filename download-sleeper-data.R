########################################
### Download Sleeper Data

# TODO:
# - Seperate script for functions
########################################

# Load packages
library(tidyverse)
library(httr2)
library(jsonlite)

# User information
config <- config::get()

# Download data functions - Player Data
download_player_data <- function(request) { 
  # Request
  req <- request(request)
  
  # Perform request
  resp <- req_perform(req)
  
  # Create dataframe
  data <- resp |> resp_body_json()
  df <- do.call(rbind, data)
  
  # Remove index
  df <- cbind(newColName = rownames(df), df)
  names(df)[names(df) == 'newColName'] <- 'sleeper_id'
  rownames(df) <- NULL
  
}

# Download player data
url_string <- "https://api.sleeper.app/v1/players/nfl"
test_df <- perform_request(url_string)
