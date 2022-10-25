
library(shiny)



# Define server logic ----
server <- function(input, output) {
  
  output$plot <- renderPlot({
    plot(sp)
    
  })
  
}

# Define UI ----
ui <- basicPage(
  plotOutput("plot")
)

# Run the app ----
shinyApp(ui = ui, server = server)
