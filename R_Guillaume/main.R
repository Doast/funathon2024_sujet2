source("R_Guillaume/create_data_list.R")
source("R_Guillaume/import_data.R")  
source("R_Guillaume/clean_dataframe.R")

library(readr)
library(dplyr)
library(stringr)
library(sf)
library(plotly)

MONTHS_LIST = 1:12

# Load data ----------------------------------

pax_apt_all <- import_airport_data(
  c("airports/ASP_APT_2018.csv",
    "airports/ASP_APT_2019.csv",
    "airports/ASP_APT_2020.csv",
    "airports/ASP_APT_2021.csv",
    "airports/ASP_APT_2022.csv",
    "airports/ASP_APT_2023.csv")
)
pax_cie_all <- import_compagnies_data(
  c("compagnies/ASP_CIE_2018.csv",
    "compagnies/ASP_CIE_2019.csv",
    "compagnies/ASP_CIE_2020.csv",
    "compagnies/ASP_CIE_2021.csv",
    "compagnies/ASP_CIE_2022.csv",
    "compagnies/ASP_CIE_2023.csv")
  )
pax_lsn_all <- import_liaisons_data(
  c("liaisons/ASP_LSN_2018.csv",
    "liaisons/ASP_LSN_2019.csv",
    "liaisons/ASP_LSN_2020.csv",
    "liaisons/ASP_LSN_2021.csv",
    "liaisons/ASP_LSN_2022.csv",
    "liaisons/ASP_LSN_2023.csv")
)

urls <- create_data_list("sources.yml")
airports_location <- sf::st_read(urls$geojson$airport)

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]

pax_apt_all$trafic <- pax_apt_all$apt_pax_dep + pax_apt_all$apt_pax_tr + pax_apt_all$apt_pax_arr

pax_apt_default <- pax_apt_all %>% filter(apt == default_airport)

