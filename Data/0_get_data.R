
# This file is to trim down the 400MB data

library(tidyverse)

# Download and unzip file -----------------------------------------------------------
googledrive::drive_download("https://drive.google.com/file/d/1IeaDpJNqfgUZzGdQmR6cz2H3EQ3_QfCV",
                            overwrite = TRUE)


dir.create("raw", showWarnings = FALSE)

# Extract just the specified data files
unzip("ships_04112020.zip", exdir = "raw")
unlink("ships_04112020.zip")

# Read-in Data ------------------------------------------------------------
dat <- data.table::fread("raw/ships.csv") %>% as_tibble()

unlink("raw/ships.csv")


# Variables description ---------------------------------------------------

# LAT - ship’s latitude
# LON - ship’s longitude
# SPEED - ship’s speed in knots
# COURSE - ship’s course as angle
# HEADING - ship’s compass direction
# DESTINATION - ship’s destination (reported by the crew)
# FLAG - ship’s flag
# LENGTH - ship’s length in meters
# SHIPNAME - ship’s name
# SHIPTYPE - ship’s type
# SHIP_ID - ship’s unique identifier
# WIDTH - ship’s width in meters
# DWT - ship’s deadweight in tones
# DATETIME - date and time of the observation
# PORT - current port reported by the vessel
# Date - date extracted from DATETIME
# Week_nb - week number extracted from date
# Ship_type - ship’s type from SHIPTYPE
# Port - current port assigned based on the ship’s location
# is_parked - indicator whether the ship is moving or not 

# Data clean up -----------------------------------------------------------

# Manual fixing some ship names
dat$SHIPNAME[grep(". PRINCE OF WAVES", dat$SHIPNAME)] <- "PRINCE OF WAVES"
dat$SHIPNAME[grep(".WLA-311", dat$SHIPNAME)] <- "WLA-311"


ships_fulldat <-
  dat %>%
  mutate(Vessel = paste0(SHIPNAME)) %>%
  select(LAT, LON, Vessel, ship_type, DATETIME, SPEED, 
         is_parked, FLAG) 


ships_stats_dat <-
  ships_fulldat %>%
  filter(is_parked == 0) %>%
  arrange(Vessel, DATETIME) %>%
  group_by(Vessel, FLAG, ship_type) %>%
  mutate(Distance = 
           geosphere::distHaversine(cbind(LON, LAT),
                                    cbind(lag(LON), lag(LAT)))) %>%
  summarise(
    Distance_sum = sum(Distance, na.rm = TRUE),
    Distance_max = max(Distance, na.rm = TRUE),
    Start_Lon = first(LON), 
    Start_Lat = first(LAT),
    End_Lon = last(LON),
    End_Lat = last(LAT),
    .groups = "drop"
  )
  

ships_fulldat <- 
  ships_fulldat %>%
  select(LAT, LON, Vessel, ship_type, SPEED, DATETIME) 


# Save the data as an RDS file ---------------------------------------------------
saveRDS(ships_fulldat, "rds/ships_fulldat.rds")

saveRDS(ships_stats_dat, "rds/ships_stats_dat.rds")



  



