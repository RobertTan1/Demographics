header <- dashboardHeader(
  title = "Big Bucks Coffee - Marketing",
  titleWidth = "300px"
)

sidebar <- dashboardSidebar(
  width = "300px",
  numericInput("n_data", "Number of customers to simulate", 1500, min=100,max=3000,step=100),
  actionButton("generate_n_data", "Simulate", icon = icon("play",lib="font-awesome"))
)

body <- dashboardBody(
  google_mapOutput("map"),
  tabBox(
    id="maintab",
    tabPanel(
      "Map",
      google_mapOutput("map")
    ),
    tabPanel(
      "Campaign",
      
    )
  ),
  
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
