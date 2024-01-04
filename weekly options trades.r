library(tidyquant)
library(dplyr)
library(plotly)


ticker <- c("MSFT")
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
  mutate(week_move = ((Close_Week_End - Open_Week_Start)/Open_Week_Start)*100) %>%
  filter(Week != 1 & week_move < 0)      


print(weekly_move)

#Max % decease
max_drop <- min(weekly_move$week_move)
#boxplot(weekly_move$week_move, ylab="Percent Drop", xlab=ticker, horizontal=TRUE)

#adding jittered point  https://plotly.com/r/box-plots/
option_box <- plot_ly(y= weekly_move$week_move, type = "box", boxpoints = "all", jitter = 0.3,
               pointpos = -1.8, name = ticker)
option_box <- option_box %>% layout(title = "Percentage Drop")
option_box





