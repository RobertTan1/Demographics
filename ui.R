header <- dashboardHeader(title = "Big Bucks Coffee - Marketing",
                          titleWidth = "300px")

sidebar <- dashboardSidebar(
  width = "300px",
  sidebarMenu(
    menuItem(
      tabName = "mapview",
      text = "Map View",
      icon = icon("globe", lib = "font-awesome")
    ),
    menuItem(
      tabName = "emailview",
      text = "Email Campaign",
      icon = icon("bolt", lib = "font-awesome")
    )
  ),
  numericInput(
    "n_data",
    "Number of customers to simulate",
    1500,
    min = 100,
    max = 3000,
    step = 100
  ),
  actionButton(
    "generate_n_data",
    "Simulate",
    icon = icon("play", lib = "font-awesome")
  )
)

body <- dashboardBody(
                      tabItems(
                        tabItem("mapview",
                          google_mapOutput("map")
                        ),
                        tabItem("emailview",
                          h2("Email campaign markdown here")
                        )
                      ),
                      tags$head(
                        tags$style(
                          HTML("
                             #generate_n_data {
                             float: right;
                             margin-right: 15px;
                             }
                             ")
                          )
                        )
                      )

ui <- dashboardPage(header, sidebar, body)

shinyApp(ui, server)
