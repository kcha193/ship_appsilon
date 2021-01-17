# 
# 
# 
# 
# map_server <-
#   function(id, dat_full_output, dat_stats_output) {
#     moduleServer(
#       id,
#       function(input, output, session) {
#         
#         dat_full_output <- dat_full_output()
#         dat_stats_output <- dat_stats_output()        
#         
#         m <-
#           reactive({
#             
#             
#             info <- paste0(
#               "<H3>Ship infomation</H3>",
#               "<strong>Vessel Name</strong>: ",
#               dat_stats_output$Vessel,
#               "<br>",
#               "<strong>Vessel Type</strong>: ",
#               dat_stats_output$ship_type,
#               "<br>",
#               
#               "<strong>Vessel Flag</strong>: ",
#               dat_stats_output$FLAG,
#               "<br>",
#               
#               "<strong>Last reported Port</strong>: ",
#               dat_stats_output$PORT,
#               "<br>",
#               
#               "<strong>Last reported destination</strong>: ",
#               dat_stats_output$DESTINATION,
#               "<br>",
#               
#               "<strong>Date time range</strong>: <br> ",
#               format(
#                 min(dat_stats_output$DATETIME),
#                 "&nbsp &nbsp <B>Start</B>: %a %b/%d/%y %I:%M %p %Z"
#               ),
#               " - <br>",
#               format(
#                 max(dat_stats_output$DATETIME),
#                 "&nbsp &nbsp <B>End</B>: %a %b/%d/%y %I:%M %p %Z"
#               ),
#               "<br>",
#               
#               "<strong>Max Distance</strong>: ",
#               scales::comma(dat_stats_output$Distance_max,
#                             accuracy = 0.1),
#               "m <br>",
#               
#               "<strong>Total Distance</strong>: ",
#               scales::comma(dat_stats_output$Distance_sum,
#                             accuracy = 0.1),
#               "m"
#             )
#             
#             
#             dat_full_output %>%
#               leaflet() %>%
#               addTiles() %>%
#               addPolylines(lng = ~ LON,
#                            lat = ~ LAT,
#                            popup = info) %>%
#               addMarkers(data = dat_stats_output,
#                          ~ Start_Lon , ~  Start_Lat, label = "Start") %>%
#               addMarkers(data = dat_stats_output,
#                          ~ End_Lon , ~  End_Lat, label = "End")
#             
# 
#           })
# 
#         return(m)
#       }
#     )
# 
#   }