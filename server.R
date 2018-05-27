library(shiny)          # For shiny app
library(shinydashboard) # For dashboard ui framework
library(googleway)      # For mapping

customers <- readRDS("customers.RDS")

server <- shinyServer(function(input, output, session) {
  customer.filter <- sample_n(customers, input$generate_n_data)
  
  output$map <- renderGoogle_map({
    google_map(
      
      key=key
    )
  })
})


