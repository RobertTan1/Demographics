library(shiny)          # For shiny app
library(shinydashboard) # For dashboard ui framework
library(googleway)      # For mapping

customer.data <- readRDS("customer.data.RDS")

server <- shinyServer(function(input, output, session) {
  cusomter.filter <- sample_n(customer.data, input$generate_n_data)
  
  google_map({
    
  })
  
})


