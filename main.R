
ticker <- toupper(c("soxl"))

days_back <- 100
#strike_price <- 11

from.date <- Sys.Date()-days_back
to.date <- Sys.Date()

source("C:\\Users\\wi\\R Projects\\StrikePrice\\strike option.R")
source("C:\\Users\\wi\\Documents\\R Projects\\StrikePrice\\yahoo options.R")
source("C:\\Users\\wi\\Documents\\R Projects\\StrikePrice\\option viz.R")

#show plot
sp


