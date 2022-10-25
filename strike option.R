library(tidyquant)
library(dplyr)
library(lubridate)

options(warn = -1)
ticker <- c("F")

from.date <- "2022-08-01"
to.date <- "2022-10-24"

#####################################################Build dataset############################
df <- tq_get(x = ticker, from = from.date, to = to.date)
df2 <- select(df, symbol, date, close)

#getting the last day of the week
df_weekly <- df2 %>%
  group_by(symbol) %>%
  tq_transmute(select = close, mutate_fun = to.weekly, indexAt = "lastof")

#########################################################################################


#add new % change column
df3 <- df_weekly %>% arrange(date) %>%
  mutate(pct_change = (close/lag(close) - 1) * 100)

#get the max %
top_percent <- (max(df3$pct_change , na.rm = TRUE)*0.01)

#get avg % 
avg_percent <- mean(df3$pct_change, na.rm = TRUE)

#get the last price
last_price <- tail(df3$close, n=1)

#Target Strike Price
#level_1_target <- last_price * avg_percent
#level_1_strike <- level_1_target + last_price

#Max Strike Price
level_2_target <- last_price * top_percent
level_2_strike_max <- level_2_target + last_price

#Strike Price
#level_1_strike
level_2_strike_max

below_strike <-(round(level_2_strike_max) - last_price)/last_price
paste(ticker, ", Strike Price:", round(level_2_strike_max), "Below Strike By:", (below_strike*100))











