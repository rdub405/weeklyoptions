library(rvest)
library(tidyverse)
library(dplyr)

ticker <- "F"

calls <- paste0('https://finance.yahoo.com/quote/',ticker,'/options?p=',ticker,'')
# Use read_html to fetch the webpage
tables <- read_html(calls) %>% 
  html_nodes("table") 

df_tables <- tables %>% 
  html_nodes(xpath="/html/body/div[1]/div/div/div[1]/div/div[3]/div[1]/div/div[2]/div/div/section/section[1]/div[2]/div/table/tbody") %>% 
  html_table()

#convert to list to a table
df_calls <- do.call(rbind.data.frame, df_tables)

#rename column names
df_calls <- df_calls %>% 
  rename(
    Contract_Name = X1,
    Last_Trade = X2,
    Strike = X3,
    Last_Price = X4,
    Bid = X5,
    Ask = X6,
    Change = X7,
    Change_Per = X8,
    Volume = X9,
    Open_Interest = X10,
    Implied_Vol = X11
  )

#add new column
df_calls$symbol <- ticker

ticker_df <- df_calls %>%
              select(symbol,Contract_Name, Strike,Last_Price, Volume, Open_Interest)

