

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Options Data Viewer Input"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("tickerInput", "Enter Ticker", "BABA"),
      actionButton("submitBtn", "Submit")
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Chart", plotOutput("plot")),
        tabPanel("OptionChain", tableOutput("earningsTable")),
        tabPanel("Past Earnings", tableOutput("dataTable")),
        tabPanel("Analyst Ratings", tableOutput("dataTable")),
        tabPanel("Strike Price", tableOutput("dataTable"))
      )
    )
  )   
)
# Define server logic required to draw a histogram
# Server logic
server <- function(input, output,session) {
  
  # Display option data in a table
  
  output$current_price <- renderTable(current_price)
  
  output$plot <- renderPlot({
    chartSeries(get(ticker), theme = chartTheme("white"),
                type = "candlesticks",subset='2023', TA = c(addBBands()))
                addRSI()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
