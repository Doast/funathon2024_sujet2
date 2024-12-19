library(readr)
library(dplyr)

# import des données
urls <- create_data_list("sources.yml")

# données aéroport

url_airport <- "https://www.data.gouv.fr/fr/datasets/r/75aa06d3-21ed-4a1f-8cbe-cda84fcfd140"

temp <- tempfile()
download.file(url_airport,temp)
unzip(temp,exdir="airports")

clean_dataframe <- function(df){
  
  df <- df %>% 
    mutate(
      an = substr(ANMOIS, 1, 4),
      mois = substr(ANMOIS, 5, 6),
      mois = ifelse(substr(mois,1,1)=="0", substr(mois,2,3), mois)
    )
  colnames(df) <- tolower(colnames(df))
  df
  
}

import_airport_data <- function(list_files){
  
  airports <- read_csv2(
    
    file = list_files,
    col_types = cols(
      ANMOIS = col_character(),
      APT = col_character(),
      APT_NOM = col_character(),
      APT_ZON = col_character(),
      .default = col_double()
    )
    
  )
  
  clean_dataframe(airports)
  
}

airports <- import_airport_data(
  
  c("airports/ASP_APT_2018.csv",
    "airports/ASP_APT_2019.csv",
    "airports/ASP_APT_2020.csv",
    "airports/ASP_APT_2021.csv",
    "airports/ASP_APT_2022.csv",
    "airports/ASP_APT_2023.csv")
  
)

# données compagnies

url_compagnies <- "https://www.data.gouv.fr/fr/datasets/r/27889c6b-7132-4b6c-9b13-71d0367fedd9"

temp <- tempfile()
download.file(url_compagnies,temp)
unzip(temp,exdir="compagnies")


import_compagnies_data <- function(list_files){
  
  airports <- read_csv2(
    
    file = list_files,
    col_types = cols(
      ANMOIS = col_character(),
      CIE = col_character(),
      CIE_NOM = col_character(),
      CIE_NAT = col_character(),
      CIE_PAYS = col_character(),
      .default = col_double()
    )
    
  )
  
  clean_dataframe(airports)
  
}

compagnies <- import_compagnies_data(
  
  c("compagnies/ASP_CIE_2018.csv",
    "compagnies/ASP_CIE_2019.csv",
    "compagnies/ASP_CIE_2020.csv",
    "compagnies/ASP_CIE_2021.csv",
    "compagnies/ASP_CIE_2022.csv",
    "compagnies/ASP_CIE_2023.csv")
  
)

# données liaisons

url_liaisons <- "https://www.data.gouv.fr/fr/datasets/r/5d2e4a84-ece5-4cdf-934f-281c178e4dc5"

temp <- tempfile()
download.file(url_liaisons,temp)
unzip(temp,exdir="liaisons")


import_liaisons_data <- function(list_files){
  
  liaisons <- read_csv2(
    
    file = list_files,
    col_types = cols(
      ANMOIS = col_character(),
      LSN = col_character(),
      LSN_DEP_NOM = col_character(),
      LSN_ARR_NOM = col_character(),
      LSN_SCT = col_character(),
      LSN_FSC = col_character(),
      .default = col_double()
    )
    
  )
  
  clean_dataframe(liaisons)
  
}

liaisons <- import_liaisons_data(
  
  c("liaisons/ASP_LSN_2018.csv",
    "liaisons/ASP_LSN_2019.csv",
    "liaisons/ASP_LSN_2020.csv",
    "liaisons/ASP_LSN_2021.csv",
    "liaisons/ASP_LSN_2022.csv",
    "liaisons/ASP_LSN_2023.csv")
  
)

# chargement du fichier de localisation des aéroports

urls <- create_data_list("sources.yml")
urls$geojson$airport
airports_location <- sf::st_read(urls$geojson$airport)

library(leaflet)

leaflet(airports_location) %>%
  addTiles() %>%
  addMarkers(popup = ~Nom)
