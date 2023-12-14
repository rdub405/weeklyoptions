# Load required libraries
library(rvest)
library(tidyverse)
library(dplyr)

# Define the download location
download_location <- "C:\\Users\\Rlwca\\OneDrive\\Documents\\SEER"

# Define the ticker symbol
ticker <- c("PLTR")

# Function to clean and save data to CSV
clean_and_save <- function(data, prefix) {
  # Extract the date
  date <- format(Sys.Date(), "%Y%m%d")
  
  # Create a filename based on the prefix, ticker, and date
  filename <- paste(prefix, ticker, date, ".csv", sep = "_")
  
  # Save the data to CSV in the specified download location
 write.csv(data, file.path(download_location, filename))
}

# Function to scrape data from TipRanks and clean it
scrape_and_clean <- function(url, col_names, prefix) {
  # Read the HTML from the provided URL
  page <- read_html(url)
  
  # Scrape the table from the HTML
  table_data <- page %>%
    html_table()
  
  # Extract the desired table from the list
  result <- table_data[[2]]
  
  # Add a "Symbol" column with the ticker value
  symbol_column <- rep(ticker, nrow(result))
  result <- cbind(Symbol = symbol_column, result)
  
  # Print the result
  print(result)
  
  # Clean and save the data
  clean_and_save(result, prefix)
}

#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
# LULU Earnings Data

# Define the URL for earnings data
earnings_url <- paste0("https://www.tipranks.com/stocks/", ticker, "/earnings")

# Scrape and clean earnings data
scrape_and_clean(earnings_url, col_names = NULL, prefix = "Related_Price_Changes")

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

# Create an example of Result2
result2 <- data.frame(
  "Highest Price Target" = as.numeric(gsub("[^0-9.]", "", clean_table[1])),
  "Average Price Target" = as.numeric(gsub("[^0-9.]", "", clean_table[2])),
  "Lowest Price Target" = as.numeric(gsub("[^0-9.]", "", clean_table[3]))
)

# Add a "Symbol" column with the ticker value
result2 <- cbind(Symbol = ticker, result2)

# Print Result2
print(result2)

# Clean and save Result2
clean_and_save(result2, "Analyst_Ratings")

#//////////////////////////////////////////////////////////////////////////////////////////////////////////////
# LULU Analyst Ratings

# Extract text and split it into a list of numbers
numbers_list <- page_forecast %>%
  html_nodes(".mr2") %>%
  html_text() %>%
  strsplit(" ") %>%
  unlist() %>%
  .[. != ""]

# Create a data frame from the list
numbers_df <- data.frame(matrix(c(ticker, numbers_list), ncol = 4, byrow = TRUE))

# Set column names
colnames(numbers_df) <- c("Symbol", "Buy", "Hold", "Sell")

# Convert values to numbers
numbers_df[, -1] <- apply(numbers_df[, -1], 2, as.numeric)

# Create a final data frame
result3 <- as_tibble(numbers_df)

# Print Result3
print(result3)

# Clean and save Result3
#clean_and_save(result3, "Stock_12_Months")
