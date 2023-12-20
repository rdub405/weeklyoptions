library(dplyr)

# Specify the path to your CSV file
file_path <- "C:/export files/results/AAPL.csv"

# Read the CSV file into a data frame
df <- read.csv(file_path)

# Print the first few rows of the data frame
print(head(df))


df_o_c <- df %>%
          select(Date, Open, Close)


weekly_change <- df_o_c %>%
  group_by(Week = lubridate::week(Date)) %>%
  summarize(Open_Week_Start = first(Open),
            Close_Week_End = last(Close),
            Weekly_Change = Close_Week_End - Open_Week_Start)

print(weekly_change)
