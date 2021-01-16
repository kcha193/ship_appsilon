





# Module definition, new method
map_UI <- function(id, dat) {
  ship_type_to_select <- unique(dat$ship_type)
  
  ns <- NS(id)
  tagList(
    column(
      6,
      h4("Select a vessel type"),
      dropdown_input(ns("vessel_type"),
                     ship_type_to_select,
                     value = ship_type_to_select[1])
    ),
    column(6,
           h4("Select a vessel"),
           uiOutput(ns("vessel_ui"))),
    
    segment(h4("Map"),
            leafletOutput(ns("map")))
  )
}


map_Server <- function(id, dat) {
  moduleServer(
    id,
    function(input, output, session) {
      
      ns <- NS(id)
      
      
      # Create drop-down menu for vessel comparison -------------------------------
      output$vessel_ui <- 
        renderUI({
          
          vessel_to_select <-
            dat %>%
            dplyr::filter(ship_type == input$vessel_type) %>%
            pull(Vessel) %>%
            unique()
          
          dropdown_input(ns("vessel"), vessel_to_select, value = vessel_to_select[1])
        })
      
      
      # Get the final data -----------------------------------------------------
      final_dat <- reactive({

        final_dat <-
          dat %>%
          filter(ship_type == req(input$vessel_type),
                 Vessel == req(input$vessel))
        
        
        return(final_dat)
      })
      
      
      # Boxplot ----------------------------------------------------------------
      output$map <- renderLeaflet({
        m <-
          final_dat() %>%
          leaflet() %>%
          addTiles() %>%
          addPolylines(lng = ~ LON,
                       lat = ~ LAT,
                       popup = "")
        
        
        return(m)
      })
      
    }
  )
}



