# Mapping -----------------------------------------------------------------

library(leaflet)

vessel <- "652"


ships_fulldat_single <- 
  ships_fulldat %>%
  filter(Vessel == vessel) 

ships_stats_dat_single <- 
  ships_stats_dat %>%
  filter(Vessel == vessel) 


info <- paste0(
  "<strong>Vessel Type</strong>: ", 
  ships_stats_dat_single$ship_type, "<br>",
  "<strong>Vessel Name</strong>: ", 
  ships_stats_dat_single$Vessel, "<br>",
  "<strong>Date time range</strong>: <br>",
  min(ships_fulldat_single$DATETIME), " - ",
  max(ships_fulldat_single$DATETIME), "<br>",
  "<strong>Max Distance</strong>: ", 
  scales::comma(ships_stats_dat_single$Distance_max, 
                accuracy = 0.1), "m <br>",
  "<strong>Total Distance</strong>: ", 
  scales::comma(ships_stats_dat_single$Distance_sum, 
                accuracy = 0.1), "m")


ships_fulldat_single %>%
  leaflet() %>%
  addTiles() %>%
  addPolylines(lng = ~LON, lat = ~LAT, popup = info) %>%
  addMarkers(data = ships_stats_dat_single,
             ~ Start_Lon , ~  Start_Lat, label = "Start")%>%
  addMarkers(data = ships_stats_dat_single,
             ~ End_Lon , ~  End_Lat, label = "End")
