# Load packages ----
library(shiny)
library(quantmod)


# User interface ----
ui <- fluidPage(
  titlePanel("stockVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Select a stock to examine.
        Information will be collected from Yahoo finance."),
      textInput("symb", "Symbol", "SPY"),
      
      dateRangeInput("dates",
                     "Date range",
                     start = "2023-05-01",
                     end = as.character(Sys.Date())),
      
      br(),
      
      checkboxInput("log", "Plot y axis on log scale",
                    value = FALSE)
    ),
    
    mainPanel(plotOutput("plot"),
              tableOutput("dataTable"))
  )
)

# Server logic
server <- function(input, output) {
  
  dataInput <- reactive({
    getSymbols(input$symb, src = "yahoo",
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })
  
  output$plot <- renderPlot({
    
    chartSeries(dataInput(), theme = chartTheme("white"),
                type = "candlesticks", log.scale = input$log, TA = c(addBBands()))
    addRSI()
  })
  

}

# Run the app
shinyApp(ui, server)
