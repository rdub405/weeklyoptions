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
    titlePanel("Earnings Input"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          textInput("Ticker", "Ticker", "BABA")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          textOutput("greeting"),
          tableOutput("dataTable"),
          tableOutput("earningsTable")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$greeting <- renderText({
    paste("Symbol: ", input$Ticker)
  })

  output$dataTable <- renderTable(put_strike_output_df)
  
  output$earningsTable <- renderTable(earnings_options_df)
}

# Run the application 
shinyApp(ui = ui, server = server)
