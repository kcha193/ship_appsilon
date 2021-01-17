

# Packages that users need to install -------------------------------------
pkg <- c("shiny", "shiny.semantic", "semantic.dashboard", "leaflet", 
         "googledrive", "tidyverse", "bit64")

new_pkg <- pkg[!pkg %in% installed.packages()]

if(length(new_pkg) > 0) {
  install.packages(new_pkg)
}


# Shiny app starts here ---------------------------------------------------

library(shiny)
library(shiny.semantic)
library(semantic.dashboard)
library(leaflet)

ships_fulldat <- readRDS("rds/ships_fulldat.rds")
ships_stats_dat <- readRDS("rds/ships_stats_dat.rds")

# Use the module in an application
ui <- dashboardPage(
  dashboardHeader(title = "Mapping", color = "blue"),
  
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    
    # User input box for selecting vessel types and vessel names
    box(
      title = "Choose vessel types and vessel names",
      color = "yellow",
      ribbon = FALSE,
      title_side = "top left",
      width = 6,
      fluidRow(
        dropdown_UI("user_input", ships_stats_dat),
        h4("Select a vessel"),
        uiOutput("vessel_ui")
      )
    ), 
    box(
      title = "Mapping ships' itinerary",
      color = "blue",
      ribbon = FALSE,
      title_side = "top left",
      width = 12,
      fluidRow(
       leafletOutput("map_out")
      )
    )
  )
)

server <- function(input, output, session) {
  


# Vessel dropdown ui as module --------------------------------------------

    
  vessel_output <- dropdown_server("user_input", ships_stats_dat)
  
  output$vessel_ui <- renderUI({
    vessel_output()
  })
  

  # Getting data from the selection -----------------------------------------

  
  dat_stats_output <- dat_final_server("user_input", ships_stats_dat)
  
  dat_full_output <- dat_final_server("user_input", ships_fulldat)
  
  
  
# Mapping  ----------------------------------------------------------------

  output$map_out <-
    renderLeaflet({
      
      dat_full_output <- req(dat_full_output())
      dat_stats_output <- req(dat_stats_output())

      
      info <- paste0(
        "<H3>Ship infomation</H3>",
        "<strong>Vessel Name</strong>: ",
        dat_stats_output$Vessel,
        "<br>",
        "<strong>Vessel Type</strong>: ",
        dat_stats_output$ship_type,
        "<br>",
        
        "<strong>Vessel Flag</strong>: ",
        dat_stats_output$FLAG,
        "<br>",
        
        "<strong>Last reported Port</strong>: ",
        dat_stats_output$PORT,
        "<br>",
        
        "<strong>Last reported destination</strong>: ",
        dat_stats_output$DESTINATION,
        "<br>",
        
        # "<strong>Date time range</strong>: <br> ",
        # format(
        #   min(dat_stats_output$DATETIME, na.rm = TRUE),
        #   "&nbsp &nbsp <B>Start</B>: %a %b/%d/%y %I:%M %p %Z"
        # ),
        # " - <br>",
        # format(
        #   max(dat_stats_output$DATETIME, na.rm = TRUE),
        #   "&nbsp &nbsp <B>End</B>: %a %b/%d/%y %I:%M %p %Z"
        # ),
        # "<br>",
        
        "<strong>Max Distance</strong>: ",
        scales::comma(dat_stats_output$Distance_max,
                      accuracy = 0.1),
        "m <br>",
        
        "<strong>Total Distance</strong>: ",
        scales::comma(dat_stats_output$Distance_sum,
                      accuracy = 0.1),
        "m"
      )
      
      
      dat_full_output %>%
        leaflet() %>%
        addTiles() %>%
        addPolylines(lng = ~ LON,
                     lat = ~ LAT,
                     popup = info) %>%
        addMarkers(data = dat_stats_output,
                   ~ Start_Lon , ~  Start_Lat, label = "Start") %>%
        addMarkers(data = dat_stats_output,
                   ~ End_Lon , ~  End_Lat, label = "End")
    })
  
  
}



shinyApp(ui, server)


