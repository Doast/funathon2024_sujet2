#' Représenter sur un graphique le trafic d'un aéroport
#'
#' @param .dataframe 
#' @param .aeroport 
#'
#' @return
#' @export
#'
#' @examples
plot_airport_line <- function(.dataframe,.aeroport){
  data <- .dataframe %>% 
    mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>% 
    filter(apt == .aeroport) %>% 
    mutate(date = lubridate::make_date(an, mois, "01")) %>% 
    arrange(date)
  
  fig <- plot_ly(data, x = ~date, y = ~trafic, text = ~apt_nom,
                 hovertemplate = paste("<i>Aéroport:</i> %{text}<br>Trafic: %{y}"),
                 type = 'scatter', mode = 'lines+markers')
  
  fig
}


map_leaflet_airport <- function(df, df_locations, month, year){
  
  palette <- c("green", "blue", "red")
  
  trafic_date <- df %>% 
    filter(an == year & mois == month)
  
  trafic_aeroports <- df_locations %>% 
    inner_join(trafic_date, by = c("Code.OACI"="apt"), suffix = c("","_date")) %>% 
    mutate(etiquette = paste0(Nom," : ",trafic," voyageurs"),
           volume = ntile(trafic, 3),
           color = palette[volume]
    )
  
  icons <- awesomeIcons(
    icon = 'plane',
    iconColor = 'black',
    library = 'fa',
    markerColor = trafic_aeroports$color
  )
  
  leaflet(trafic_aeroports) %>%
    addTiles() %>%
    addAwesomeMarkers(label=~paste0(Nom, "", " (",Code.OACI, ") : ", trafic, " voyageurs"), icon = icons)
}