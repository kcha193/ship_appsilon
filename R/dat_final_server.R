







dat_final_server <-
  function(id, dat) {
    moduleServer(
      id,
      ## Below is the module function
      function(input, output, session) {

        # Get the final data -----------------------------------------------------
        final_dat <- reactive({
          final_dat <-
            dat %>%
            filter(Vessel == req(input$vessel))


          return(final_dat)
        })

        return(final_dat)
      })

  }