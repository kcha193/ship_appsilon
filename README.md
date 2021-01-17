# Shiny app on mapping ships' itinerary

This README document will describe the development of this shiny application. This work can be divided into two main tasks:

-   Download the tidy up the data sets for the shiny application.

    -   Understand the question asked and the dataset provided.

    -   Using the googledrive R package to programmatically download the dataset, then unzip and saved as rds file. 
    
    -   Data is cleaned and then extracted only the variable of interests, so the file size can be reduced.

-   Build a [Shiny](https://shiny.rstudio.com) app using [shiny.semantic](https://cran.r-project.org/web/packages/shiny.semantic/index.html) R package.

    -   Understand the usage of "shiny.semantic" R package structure the UI of shiny application.
    
    -   Utilising the Shiny Module programming on the dropdown input as instructed. 
    
    -   The input above is then needed to flow through to the other shiny outputs, such as maps, line plots and value box, via data set of intesrsting within reactive expression.
    
    -   Ensure all the required information are shown clearly. 
    
    -   Ensure all the spaces of the UI are properly used in this shiny application.
    

This shiny app is also available from [shinyapps.io](https://kcha193.shinyapps.io/ship_appsilon/).
