source("R_Guillaume/create_data_list.R")
source("R_Guillaume/import_data.R")  
source("R_Guillaume/clean_dataframe.R")
source("R_Guillaume/figures.R")
source("R_Guillaume/divers_functions.R")
source("R_Guillaume/tables.R")

library(readr)
library(dplyr)
library(stringr)
library(sf)
library(plotly)
library(ggplot2)
library(plotly)
library(gt)
library(leaflet)

YEARS_LIST  <- as.character(2018:2023)
MONTHS_LIST <- 1:12
palette <- c("green", "blue", "red")

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

trafic_aeroports <- pax_apt_all %>%
  mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>%
  filter(apt %in% default_airport) %>%
  mutate(
    date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
  )

ggplot(trafic_aeroports,aes(x=date, y=trafic)) + 
  geom_line()

plot_airport_line(pax_apt_all, "LFJL")

stats_aeroports <- summary_stat_airport(pax_apt_all)

create_table_airports(stats_aeroports)

  map_leaflet_airport(pax_apt_all, airports_location, 5,2022)
