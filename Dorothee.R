library(dplyr)
library(readr)
library(stringr)
library(leaflet)

#3.3 Importer la liste des sources disponibles

sources <- yaml::read_yaml("sources.yml")

source("R_Dorothee/create_data_list.R")
source("R_Dorothee/clean_dataframe.R")
source("R_Dorothee/import_data.R")

urls <- create_data_list("sources.yml")

#3.4 Importer les premières bases
a <- unlist(urls$airports)[[2]]
airports <- readr::read_csv2(a)
#liens CSV ne sont plus fonctionnels

url_airport <- "https://www.data.gouv.fr/fr/datasets/r/75aa06d3-21ed-4a1f-8cbe-cda84fcfd140"

temp <- tempfile()
download.file(url_airport,temp)
unzip(temp,exdir="airports")

url_compagnies <- "https://www.data.gouv.fr/fr/datasets/r/27889c6b-7132-4b6c-9b13-71d0367fedd9"

temp2 <- tempfile()
download.file(url_compagnies,temp2)
unzip(temp2,exdir="compagnies")

url_liaisons <- "https://www.data.gouv.fr/fr/datasets/r/5d2e4a84-ece5-4cdf-934f-281c178e4dc5"

temp3 <- tempfile()
download.file(url_liaisons,temp3)
unzip(temp3,exdir="liaisons")

airports <- readr::read_csv2(c("airports/ASP_APT_2022.csv",
                           "airports/ASP_APT_2021.csv",
                           "airports/ASP_APT_2020.csv",
                           "airports/ASP_APT_2019.csv",
                           "airports/ASP_APT_2018.csv"),
                         ,
                         col_types = cols(
                           ANMOIS = col_character(),
                           APT = col_character(),
                           APT_NOM = col_character(),
                           APT_ZON = col_character(),
                           .default = col_double()
                         )
                         )

airports2 <- airports %>% 
  mutate(an = str_sub(ANMOIS,1,4),
         mois2 = str_sub(ANMOIS,5,7),
         mois = ifelse(str_sub(mois2,1,1)=="0",str_sub(mois2,2,3),mois2)
         )


aeroports <- clean_dataframe(airports)


aeroports <- import_airport_data(c("airports/ASP_APT_2022.csv",
                                   "airports/ASP_APT_2021.csv",
                                   "airports/ASP_APT_2020.csv",
                                   "airports/ASP_APT_2019.csv",
                                   "airports/ASP_APT_2018.csv"))



compagnies <- import_compagnies_data(c("compagnies/ASP_CIE_2022.csv",
                                       "compagnies/ASP_CIE_2021.csv",
                                       "compagnies/ASP_CIE_2020.csv",
                                       "compagnies/ASP_CIE_2019.csv",
                                       "compagnies/ASP_CIE_2018.csv"))



liaisons <- import_liaisons_data(c("liaisons/ASP_LSN_2022.csv",
                                       "liaisons/ASP_LSN_2021.csv",
                                       "liaisons/ASP_LSN_2020.csv",
                                       "liaisons/ASP_LSN_2019.csv",
                                       "liaisons/ASP_LSN_2018.csv"))

airports_location <- sf::st_read(urls$geojson$airport)

sf::st_crs(airports_location)

leaflet(airports_location) %>%
  addTiles() %>%
  addMarkers(popup = ~Nom)

#4 Exploration des données
