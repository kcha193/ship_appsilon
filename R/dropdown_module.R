


library(shiny)
library(shiny.semantic)
library(semantic.dashboard)



# Module definition, new method
dropdown_UI <- function(id, dat) {
  ship_type_to_select <- unique(dat$ship_type)
  
  ns <- NS(id)
 
  tagList(
   
    h4("Select a vessel type"),
    dropdown_input(ns("vessel_type"),
                   ship_type_to_select,
                   value = ship_type_to_select[1])
    
  )
}



dropdown_server <- function(id, dat) {
  moduleServer(
    id,
    function(input, output, session) {
      
      ns <- NS(id)
      
      # Create drop-down menu for vessel comparison -------------------------------
      vessel_ui <- 
        reactive({
          
          vessel_to_select <-
            dat %>%
            dplyr::filter(ship_type == req(input$vessel_type)) %>%
            pull(Vessel) %>%
            unique()
          
          dropdown_input(ns("vessel"), 
                         vessel_to_select, value = vessel_to_select[1])
        })
      
      
      return(vessel_ui)

    }
  )
}







# Module definition, new method
# dropdown_UI <- function(id, dat) {
#   ship_type_to_select <- unique(dat$ship_type)
#   
#   
#   
#   tagList(
#     column(
#       6,
#       h4("Select a vessel type"),
#       selectVarInput(ns(id, "vessel_type"),
#                      ship_type_to_select,
#                      value = ship_type_to_select[1])
#     ),
#     column(6,
#            h4("Select a vessel"),
#            uiOutput(ns(id, "vessel_ui")))
#   )
# }

