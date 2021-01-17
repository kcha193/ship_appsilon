


# This server function is to extract the final dataset for the shiny application

dat_final_server <-
  function(id, dat, is_long = TRUE) {
    moduleServer(id,
                 ## Below is the module function
                 function(input, output, session) {
                   
                   final_dat <- reactive({
                     
                     req(input$vessel_type)
                     req(input$vessel)
                     
                     final_dat <-
                       dat %>%
                       filter(ship_type == input$vessel_type,
                              Vessel == input$vessel)
                     
                     
                     if (is_long) {
                       final_dat <-
                         final_dat %>% arrange(DATETIME)
                     }
                     
                     return(final_dat)
                   })
                   
                   return(final_dat)
                 })
    
  }