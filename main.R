#main script to execute yahoo options and strikc options 

ticker <- c("DKNG")

from.date <- "2022-08-01"
to.date <- Sys.Date()

source("C:\\Users\\williarl\\OneDrive - Continental Resources\\Documents\\R Projects\\StrikePrice\\strike option.R")
source("C:\\Users\\williarl\\OneDrive - Continental Resources\\Documents\\R Projects\\StrikePrice\\yahoo options.R")
source("C:\\Users\\williarl\\OneDrive - Continental Resources\\Documents\\R Projects\\StrikePrice\\option viz.R")

#show plot
sp
