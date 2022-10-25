library("ggplot2")
library("ggrepel")  

sp <- ggplot(df3, 
       aes(x = date,
           y = close)) + 
        geom_bar(stat = "identity")
sp <- sp + ggtitle(paste0(ticker , " Call Strike Price at $", round(level_2_strike_max) ))
# Change line size
sp <- sp + geom_hline(yintercept=level_2_strike_max, linetype="dashed", 
                color = "red", size=2)
#add label
sp <- sp + geom_label(aes(label = close, size = NULL), nudge_y = 0.1)

sp
