# Load required libraries
library(rvest)
library(tidyverse)
library(purrr)
library(glue)

# Define the list of tickers
tickers <- c("DAL")

# Initialize data frames
result_earnings <- data.frame()
result_forecast <- data.frame()
result_ratings <- data.frame()

# Function to scrape data from TipRanks
scrape_data <- function(url, col_names, prefix, ticker) {
  # Read the HTML from the provided URL
  page <- read_html(url)
  
  # Scrape the table from the HTML
  table_data <- page %>%
    html_table()
  
  # Extract the desired table from the list
  result <- table_data[[2]]
  
  # Add Symbol column
  result$Symbol <- ticker
  
  # Print the result
  print(result)
  
  # Pause for 60 seconds
  Sys.sleep(10)
  
  # Return the result
  return(result)
}

# Function to perform web scraping for each ticker
scrape_for_ticker <- function(ticker) {
  #//////////////////////////////////////////////////////////////////////////////////////////////////////////////
  # LULU Earnings Data
  
  # Define the URL for earnings data
  earnings_url <- paste0("https://www.tipranks.com/stocks/", ticker, "/earnings")
  
  # Scrape earnings data
  result_earnings_ticker <- scrape_data(earnings_url, col_names = NULL, prefix = "Related_Price_Changes", ticker)
  
  # Append to the overall result_earnings data frame
  result_earnings <<- bind_rows(result_earnings, result_earnings_ticker)
  
  #//////////////////////////////////////////////////////////////////////////////////////////////////////////////
  # LULU 12 Months Forecast
  
  # Define the URL for 12-month forecast data
  forecast_url <- paste0("https://www.tipranks.com/stocks/", ticker, "/forecast")
  
  # Read the HTML from the forecast URL
  page_forecast <- read_html(forecast_url)
  
  # Scrape forecast data and clean it
  table_forecasts <- page_forecast %>%
    html_table()
  
  # Extract the desired table from the list
  clean_table <- table_forecasts[[1]]
  clean_table <- clean_table[, -c(4, 2)]
  
  # Create Result2 for the current ticker
  result_forecast_ticker <- data.frame(
    "Highest Price Target" = as.numeric(gsub("[^0-9.]", "", clean_table[1])),
    "Average Price Target" = as.numeric(gsub("[^0-9.]", "", clean_table[2])),
    "Lowest Price Target" = as.numeric(gsub("[^0-9.]", "", clean_table[3])),
    Symbol = ticker
  )
  
  # Append to the overall result_forecast data frame
  result_forecast <<- bind_rows(result_forecast, result_forecast_ticker)
  
  # Print Result2 for the current ticker
  print(result_forecast_ticker)
  
  #//////////////////////////////////////////////////////////////////////////////////////////////////////////////
  # LULU Analyst Ratings
  
  # Extract text and split it into a list of numbers
  numbers_list <- page_forecast %>%
    html_nodes(".mr2") %>%
    html_text() %>%
    strsplit(" ") %>%
    unlist() %>%
    .[. != ""]
  
  # Create a data frame for the current ticker
  numbers_df_ticker <- data.frame(matrix(c(ticker, numbers_list), ncol = 4, byrow = TRUE))
  
  # Set column names
  colnames(numbers_df_ticker) <- c("Symbol", "Buy", "Hold", "Sell")
  
  # Convert values to numbers
  numbers_df_ticker[, -1] <- apply(numbers_df_ticker[, -1], 2, as.numeric)
  
  # Create Result3 for the current ticker
  result_ratings_ticker <- as_tibble(numbers_df_ticker)
  
  # Append to the overall result_ratings data frame
  result_ratings <<- bind_rows(result_ratings, result_ratings_ticker)
  
  # Print Result3 for the current ticker
  print(result_ratings_ticker)
}

# Iterate over each ticker
walk(tickers, scrape_for_ticker)

# Display the final data frames
result_earnings
result_forecast
result_ratings
