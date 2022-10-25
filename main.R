#main script to execute yahoo options and strikc options 

ticker <- c("CHPT")

days_back <- 90

from.date <- Sys.Date()-days_back
to.date <- Sys.Date()

source("C:\\Users\\williarl\\OneDrive - Continental Resources\\Documents\\R Projects\\StrikePrice\\strike option.R")
source("C:\\Users\\williarl\\OneDrive - Continental Resources\\Documents\\R Projects\\StrikePrice\\yahoo options.R")
source("C:\\Users\\williarl\\OneDrive - Continental Resources\\Documents\\R Projects\\StrikePrice\\option viz.R")

#show plot
sp


