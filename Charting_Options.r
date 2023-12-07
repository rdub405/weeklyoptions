library(quantmod)



stock_chart_df <- getSymbols(ticker, from='2023-01-01',to='2023-12-07')
head(stock_chart_df)

#Open <- Op(BABA)   #Open Price
#High <- Hi(BABA)    # High price
#Low <- Lo(BABA)  # Low price
#Close<- Cl(BABA)   #Close Price
#Volume <- Vo(BABA)   #Volume

#Candle Chart
chartSeries(get(ticker),
            type="candlesticks",TA = NULL,
            subset='2023',
            theme=chartTheme('white'))
            addSMA(n=20,on=1,col = "blue")
            addSMA(n=50,on=1,col = "orange")
            addBBands(n=20,sd=2)
            addRSI(n=14,maType="EMA")
            #addSAR() #Parabolic Stop and Reverse
            addSMI()
            

#SMA 20
#sma <-SMA(Cl(BABA),n=20)
#tail(sma,n=5)

#RSI
#rsi = RSI(Cl(BABA), n=14)
#tail(rsi,n=5)
