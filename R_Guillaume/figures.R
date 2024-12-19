plot_airport_line <- function(dataframe, airport){
  
  dataframe$trafic <- dataframe$apt_pax_dep + dataframe$apt_pax_tr + dataframe$apt_pax_arr
  
  dataframe <- dataframe %>% 
    mutate(
      date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
    )
  
  plot_ly(
    dataframe %>% filter(apt == airport),
    x = ~ date,
    y = ~ trafic,
    text = ~apt_nom,
    type = 'scatter',
    mode = 'lines+markers',
    hovertemplate = paste("<i>Aéroport:</i> %{text}<br>Trafic: %{y}")
  )
  
}

map_leaflet_airport <- function(df, airports_location, months, years){
  
  trafic_date <- df %>% 
    filter(mois == months, an == years) %>% 
    mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>% 
    select(apt, trafic) %>% 
    mutate(volume = ntile(trafic, 3),
           color = palette[volume]) 
  
  trafic_aeroports <- airports_location %>% 
    select(-volume, -color, -trafic) %>% 
    inner_join(trafic_date, by=c("Code.OACI"="apt"))
  
  leaflet(data = trafic_aeroports) %>% addTiles() %>%
    addAwesomeMarkers(
      popup = ~paste0(Nom, ": ", trafic, " voyageurs"),
      icon = awesomeIcons(
        icon = 'plane',
        iconColor = 'black',
        library = 'fa',
        markerColor = trafic_aeroports$color
      )
    )
  
}