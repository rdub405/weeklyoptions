library(tidyquant)
library(dplyr)


ticker <- c("BAC")
current_price <- getQuote(ticker)

prices <- tq_get(ticker,
                 get = "stock.prices",
                 from = "2023-01-04",
                 to = "2024-01-04"
)
prices


df_o_c <- prices %>%
  select(date, open, close)

weekly_change <- df_o_c %>%
  group_by(Week = lubridate::week(date)) %>%
  summarize(Open_Week_Start = first(open),
    Close_Week_End = last(close))
    #,Weekly_Change = close - open)

weekly_move <- weekly_change %>%
  mutate(week_move = Close_Week_End - Open_Week_Start)


print(weekly_move)

#Max % decease
min(weekly_move$week_move)
