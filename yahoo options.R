
library(rvest)
library(tidyverse)
library(dplyr)
library(lubridate)
library(tidyquant)

ticker <- c("BABA")
#option_date <- c("1701993600")
current_price <- getQuote(ticker)


current_price$symbol <- ticker
current_price <- current_price %>%
  select(symbol, Last, Open)

#calls <- paste0('https://finance.yahoo.com/quote/',ticker,'/options?p=',ticker,'')
options_link <- paste0('https://finance.yahoo.com/quote/',ticker,'/options?p=',ticker,'&straddle=true')
#with date
#options_link <- paste0('https://finance.yahoo.com/quote/',ticker,'/options?date=',option_date,'&p=',ticker,'&straddle=true')

# Use read_html to fetch the webpage
tables <- read_html(options_link) %>% 
  html_nodes("table") 

df_tables <- tables %>% 
  html_nodes(xpath="/html/body/div[1]/div/div/div[1]/div/div[3]/div[1]/div/div[2]/div/div/section/section[1]/div[2]/div/table/tbody") %>% 
  html_table()

#convert to list to a table
df_options_table <- do.call(rbind.data.frame, df_tables)

#rename column names
df_options_table <- df_options_table %>% 
  rename(
    Call_Last_Price = X1,
    Call_Change_Price = X2,
    Call_Percent_Change = X3,
    Call_Volume = X4,
    Call_Open_Interest = X5,
    Strike = X6,
    Put_Last_Price = X7,
    Put_Change = X8,
    Put_Percent_Change = X9,
    Put_Volume = X10,
    Put_Open_Interest = X11
  )

#add new columns
df_options_table$symbol <- ticker
df_options_table$ExpDate <- option_date
#df_options_table$ExpDate <-ceiling_date(Sys.Date(), "week", week_start = getOption("lubridate.week.start", 1))-3


current_price_df <- current_price %>%
  select(symbol, Last)


#######################Earnings table #############################
earnings_options_df <- df_options_table %>%
  select(symbol,
         ExpDate,
         Call_Last_Price,
         Call_Volume,
         Call_Open_Interest,
         Strike,
         Put_Last_Price,
         Put_Volume,
         Put_Open_Interest) %>%
          filter(!is.null(Put_Open_Interest))
###################################the price closest to the strike price#####################
output_df <- earnings_options_df %>% 
            inner_join(current_price_df) %>%
            mutate(dif = abs(Strike-Last)) %>%
            group_by(symbol) %>%
            filter(dif ==min(dif))

output_df$expected_move <- (as.numeric(output_df$Call_Last_Price) + as.numeric(output_df$Put_Last_Price))
output_df$expected_percentage <- (as.numeric(output_df$expected_move) / as.numeric(output_df$Last))*100
output_df$put_strike <- (as.numeric(output_df$Last) - as.numeric(output_df$expected_move))

strike_output_df <- output_df %>%
                    select(symbol, ExpDate, Strike, Last, expected_move, put_strike, expected_percentage)

put_strike_price_df <-strike_output_df %>%
  select(symbol, put_strike, expected_percentage)

#######################################################getting strike price#################
put_strike_output_df <- earnings_options_df %>% 
  inner_join(put_strike_price_df) %>%
  mutate(dif = abs(Strike-put_strike)) %>%
  group_by(symbol) %>%
  filter(dif ==min(dif))

put_strike_output_df <- put_strike_output_df %>% 
    select(symbol, ExpDate, Strike,"Premiums" = Put_Last_Price )
       
###########################################boxplot#############################

OI_values <- earnings_options_df[earnings_options_df$Put_Open_Interest != "-",]
OI_values$Put_Open_Interest <- as.numeric(OI_values$Put_Open_Interest)

boxplot(t(OI_values$Put_Open_Interest))
#class(OI_values$Put_Open_Interest)                 
         
