
# Note that there is NO need to run this file as this R script is to perform some
# initial testing on mapping using leaflet R package
# 
# File: 0_test_map.R
# 
# Date: 2021-01-17
# 
# Developer: Kevin Chang
#  
# This purpose of R script is to perform some initial testing on mapping
# using leaflet R package.

# Load the file for mapping -----------------------------------------------

ships_fulldat <- readRDS("rds/ships_fulldat.rds")
ships_stats_dat <- readRDS("rds/ships_stats_dat.rds")


# Mapping -----------------------------------------------------------------
library(tidyverse)
library(leaflet)

vessel <- "AURA (Ship_ID: 346022)"


ships_fulldat_single <- 
  ships_fulldat %>%
  filter(Vessel == vessel) 

ships_stats_dat_single <- 
  ships_stats_dat %>%
  filter(Vessel == vessel) 


info <- paste0(
  "<H3>Ship infomation</H3>",
  "<strong>Vessel Name</strong>: ", 
  ships_stats_dat_single$Vessel, "<br>",
  "<strong>Vessel Type</strong>: ", 
  ships_stats_dat_single$ship_type, "<br>",
  
   "<strong>Vessel Flag</strong>: ", 
  ships_stats_dat_single$FLAG, "<br>",
  
  "<strong>Last reported Port</strong>: ", 
  ships_stats_dat_single$PORT, "<br>",
  
  "<strong>Last reported destination</strong>: ", 
  ships_stats_dat_single$DESTINATION, "<br>",
  
  "<strong>Date time range</strong>: <br> ",
  format(min(ships_fulldat_single$DATETIME),
         "&nbsp &nbsp <B>Start</B>: %a %b/%d/%y %I:%M %p %Z"), " - <br>",
   format(max(ships_fulldat_single$DATETIME), 
          "&nbsp &nbsp <B>End</B>: %a %b/%d/%y %I:%M %p %Z"), "<br>",
  
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



