

# Packages that users need to install -------------------------------------
# pkg <- c("shiny", "shiny.semantic", "semantic.dashboard", "leaflet",
#          "googledrive", "tidyverse", "bit64")
# 
# new_pkg <- pkg[!pkg %in% installed.packages()]
# 
# if(length(new_pkg) > 0) {
#   install.packages(new_pkg)
# }


# Shiny app starts here ---------------------------------------------------

library(tidyverse)
library(plotly)
library(shiny)
library(leaflet)
library(shiny.semantic)
library(semantic.dashboard)


ships_fulldat <- readRDS("rds/ships_fulldat.rds")
ships_stats_dat <- readRDS("rds/ships_stats_dat.rds")


# Use the module in an application
ui <- dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
   
    h1("Shiny application showing the itineraries of different selected ships"),
   
 
    fluidRow(
    column(width = 9,
           box(
             title = "Mapping ships' itinerary and ploting speed over time",
             color = "blue",
             ribbon = FALSE,
             title_side = "top left",
             width = 12,
             fluidRow(
               
               h3("Please click on the route for more information"),
               leafletOutput("map_out"),
               plotlyOutput("line_plot")
               
             )
             )
           ),
    
    # Some overall stats
    column(width = 3,
       box(
        title = "Overall stats",
        color = "teal",
        ribbon = FALSE,
        title_side = "top left",
        width = 12,
        fluidRow(
          
          valueBox(
            "ships in total",
            value = scales::comma(nrow(ships_stats_dat)),
            color = "blue", width = 12, size = "small"),
          
          h4("Data was collected in between"),
          valueBox(
            "",
            value = format(min(ships_fulldat$DATETIME), "%Y/%m/%d"),
            color = "blue", width = 12, size = "mini"),
          h4("and"),
          valueBox(
            "",
            value = format(max(ships_fulldat$DATETIME), "%Y/%m/%d"),
            color = "blue", width = 12, size = "mini")
        )
      ),     
           
    # User input box for selecting vessel types and vessel names
      box(
        title = "Choose a vessel",
        color = "yellow",
        ribbon = FALSE,
        title_side = "top left",
        width = 12,
        fluidRow(
          dropdown_UI("user_input", ships_stats_dat),
          h4("Select a vessel"),
          uiOutput("vessel_ui")
        )
      ),
    
     box(
        title = "Selected vessel stats",
        color = "red",
        ribbon = FALSE,
        title_side = "top left",
        width = 12,
        fluidRow(
          
          h4("Maximum distance between two points"),
          value_box_output("max_dist"),
          h4("Total distance travelled"),
          value_box_output("total_dist"),
          h4("Maximum speed"),
          value_box_output("max_speed")
        )
      ),
    

    )
    )))

server <- function(input, output, session) {
  


# Vessel dropdown ui as module --------------------------------------------

    
  vessel_output <- dropdown_server("user_input", ships_stats_dat)
  
  output$vessel_ui <- renderUI({
    vessel_output()
  })
  

  # Getting data from the selection -----------------------------------------

  
  dat_stats_output <- dat_final_server("user_input", ships_stats_dat, is_long = FALSE)
  
  dat_full_output <- dat_final_server("user_input", ships_fulldat)
  
  
  # Couple value box showing the max and total distance ------------
  
  output$max_dist <-
    renderValueBox({
      valueBox(
        "meter",
        value = scales::comma(req(dat_stats_output())$Distance_max,
                             accuracy = 0.1),
               color = "blue", width = 12, size = "small")
    })
  
  output$total_dist <-
    renderValueBox({
      valueBox(
        "meter",
        value = scales::comma(req(dat_stats_output())$Distance_sum,
                             accuracy = 0.1),
               color = "green", size = "small", width = 12)
    })
  
  output$max_speed <-
    renderValueBox({
      valueBox(
        "knot",
        value = scales::comma(max(req(dat_full_output())$SPEED, na.rm = TRUE),
                             accuracy = 0.1),
               color = "blue", width = 12, size = "small")
    })
  
# Plotting speed ---------------------------------------------------------
  
  output$line_plot <- 
    renderPlotly({

      req(dat_full_output())
      
      g <- 
        ggplot(data = dat_full_output(), 
               aes(x = DATETIME, y = SPEED)) +
        geom_path() + 
        geom_point() + 
        theme_classic() +
        labs(title = "Showing the speed of selected ship over time", 
             y = "Ship’s speed (in knots)",
             x = "Date and time of the observation")
        
      ggplotly(g)
    })
  
  
# Mapping  ----------------------------------------------------------------

  output$map_out <-
    renderLeaflet({
      
      req(dat_full_output())
      req(dat_stats_output())
      
      dat_stats <- dat_stats_output()
      dat_full <- dat_full_output()
     

      info <- paste0(
        "<H3>Ship infomation</H3>",
        "<strong>Vessel Name</strong>: ",
        dat_stats$Vessel,
        "<br>",
        "<strong>Vessel Type</strong>: ",
        dat_stats$ship_type,
        "<br>",
        
        "<strong>Vessel Flag</strong>: ",
        dat_stats$FLAG,
        "<br>",
        
        "<strong>Last reported Port</strong>: ",
        dat_stats$PORT,
        "<br>",
        
        "<strong>Last reported destination</strong>: ",
        dat_stats$DESTINATION,
        "<br>",
        
        "<strong>Date time range</strong>: <br> ",
        format(
          min(dat_full$DATETIME, na.rm = TRUE),
          "&nbsp &nbsp <B>Start</B>: %a %b/%d/%y %I:%M %p %Z"
        ),
        " - <br>",
        format(
          max(dat_full$DATETIME, na.rm = TRUE),
          "&nbsp &nbsp <B>End</B>: %a %b/%d/%y %I:%M %p %Z"
        ),
        "<br>",
        
        "<strong>Max Distance</strong>: ",
        scales::comma(dat_stats$Distance_max,
                      accuracy = 0.1),
        "m <br>",
        
        "<strong>Total Distance</strong>: ",
        scales::comma(dat_stats$Distance_sum,
                      accuracy = 0.1),
        "m"
      )
      
  
      leaflet(dat_full) %>%
        addTiles() %>%
        addPolylines(lng = ~ LON, lat = ~ LAT, popup = info) %>%
        addMarkers(data = dat_stats,
                   ~ Start_Lon , ~  Start_Lat, label = "Start",
                   labelOptions = labelOptions(noHide = TRUE)) %>%
        addMarkers(data = dat_stats, 
                   ~ End_Lon , ~  End_Lat, label = "End",
                   labelOptions = labelOptions(noHide = TRUE))
    })
  
  
}



shinyApp(ui, server)


