#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Options Data Viewer Input"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          textInput("tickerInput", "Enter Ticker", "BABA"),
          hr(), # Add a horizontal rule
          actionButton("submitBtn", "Submit")
        ),
        

        # Show a plot of the generated distribution
        
        mainPanel(plotOutput("plot"),
                  tableOutput("dataTable"),
                  tableOutput("dataTableStrike"))
    )
)
        
        

# Define server logic required to draw a histogram
server <- function(input, output,session) {

  # Display option data in a table
  
  output$dataTable <- renderTable(earnings_options_df)
  
  output$dataTableStrike <- renderTable(strike_output_df)
  
  output$plot <- renderPlot({
    chartSeries(BABA, theme = chartTheme("white"),
                type = "candlesticks",subset='2023', TA = NULL)
                addRSI(n=14,maType="EMA")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
