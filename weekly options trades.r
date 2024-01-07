library(tidyquant)
library(dplyr)
library(plotly)


ticker <- c("DAL")
current_price <- getQuote(ticker)


prices <- tq_get(ticker,
                 get = "stock.prices",
                 from = "2023-01-04",
                 to = Sys.Date())
#Price table
#prices

current_price$symbol <- ticker
current_price <- current_price %>%
  select(symbol, Last)
#price now
price_now <- current_price$Last

#Open and close by date table
df_o_c <- prices %>%
  select(date, open, close)

weekly_change <- df_o_c %>%
  group_by(Week = lubridate::week(date)) %>%
  summarize(Open_Week_Start = first(open),
            Close_Week_End = last(close))

weekly_move <- weekly_change %>%
  mutate(week_move = ((Close_Week_End - Open_Week_Start)/Open_Week_Start)*100) %>%
  filter(Week != 1 & week_move < 0)      

#print(weekly_move)

#Max % decease
max_drop <- abs(min(weekly_move$week_move))

#BOXPLOT adding jittered point  https://plotly.com/r/box-plots/
option_box <- plot_ly(y= abs(round((weekly_move$week_move),digits = 1)), type = "box", boxpoints = "all", jitter = 0.3,
                      pointpos = -1.8, name = ticker)
option_box <- option_box %>% layout(title = "Percentage Drop")
option_box

#option_scatter <- plot_ly(data = earnings_options_df, y = ~earnings_options_df$Strike, x = ~earnings_options_df$Put_Open_Interest
#                          , type = "scatter", mode = "markers")
#option_scatter

#start to build out quartiles 
data <- abs(round((weekly_move$week_move),digits = 1))
quartiles <- fivenum(data)
quart_four <-quartiles[4]
IQR <- quartiles[4] - quartiles[2]
upper_fence <- quartiles[3] + 1 * IQR 
cat("Q3:", quart_four)

quart_percentage <- (quart_four / 100)
upper_fence_percentage <- (upper_fence / 100)
first_target_strike <- price_now - (price_now * quart_percentage)
second_target_strike <- price_now - (price_now * upper_fence_percentage)

cat("Current Price: $",price_now , "\n")
cat("First Target Strike Price: $",round(first_target_strike), "\n")
cat("Second Target Strike Price: $",round(second_target_strike), "\n")
