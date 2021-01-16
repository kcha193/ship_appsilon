



library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(leaflet)

ships_dat <- readRDS("Data/ships_dat.rds")

# Use the module in an application
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  
  dashboardSidebar(disable = TRUE),
  dashboardBody(fluidRow(box(
    map_UI("test", ships_dat)
  )))
)

server <- function(input, output, session) {
  map_Server("test", ships_dat)
}



shinyApp(ui, server)


