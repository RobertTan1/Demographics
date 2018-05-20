header <- dashboardHeader(
  title = "Big Bucks Coffee - Marketing",
  titleWidth = "300px"
)

sidebar <- dashboardSidebar(
  width = "300px",
  numericInput("n_data", "Number of customers to simulate", 5000, min=1000,max=50000,step=1000),
  actionButton("generate_n_data", "Simulate", icon = icon("play",lib="font-awesome"))
)

body <- dashboardBody(
  google_mapOutput("map"),
  tags$head(
    tags$style(
      HTML(
        "
          #generate_n_data {
            float: right;
            margin-right: 15px;
          }
          
        "
      )
    )
  )
)

ui <- dashboardPage(header,sidebar,body)

shinyApp(ui, server)
