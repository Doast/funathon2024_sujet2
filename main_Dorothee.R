# Load data ----------------------------------

library(dplyr)
library(readr)
library(stringr)
library(sf)
library(plotly)
library(gt)
library(leaflet)

source("R_Dorothee/create_data_list.R")
source("R_Dorothee/import_data.R")  
source("R_Dorothee/clean_dataframe.R")
source("R_Dorothee/figures.R")
source("R_Dorothee/tables.R")
source("R_Dorothee/divers_functions.R")

YEARS_LIST  <- as.character(2018:2022)
MONTHS_LIST <- 1:12
year <- YEARS_LIST[1]
month <- MONTHS_LIST[1]

urls <- create_data_list("./sources.yml")

pax_apt_all <- import_airport_data(c("airports/ASP_APT_2022.csv",
                                     "airports/ASP_APT_2021.csv",
                                     "airports/ASP_APT_2020.csv",
                                     "airports/ASP_APT_2019.csv",
                                     "airports/ASP_APT_2018.csv"))
pax_cie_all <- import_compagnies_data(c("compagnies/ASP_CIE_2022.csv",
                                        "compagnies/ASP_CIE_2021.csv",
                                        "compagnies/ASP_CIE_2020.csv",
                                        "compagnies/ASP_CIE_2019.csv",
                                        "compagnies/ASP_CIE_2018.csv"))
pax_lsn_all <- import_liaisons_data(c("liaisons/ASP_LSN_2022.csv",
                                      "liaisons/ASP_LSN_2021.csv",
                                      "liaisons/ASP_LSN_2020.csv",
                                      "liaisons/ASP_LSN_2019.csv",
                                      "liaisons/ASP_LSN_2018.csv"))

airports_location <- st_read(urls$geojson$airport)

liste_aeroports <- unique(pax_apt_all$apt)
default_airport <- liste_aeroports[1]

# OBJETS NECESSAIRES A L'APPLICATION ------------------------

trafic_aeroports <- pax_apt_all %>%
  mutate(trafic = apt_pax_dep + apt_pax_tr + apt_pax_arr) %>%
  filter(apt %in% default_airport) %>%
  mutate(
    date = as.Date(paste(anmois, "01", sep=""), format = "%Y%m%d")
  )

stats_aeroports <- summary_stat_airport(
  create_data_from_input(trafic_aeroports, year, month)
)

stats_aeroports_table <- stats_aeroports %>%
  mutate(name_clean = paste0(str_to_sentence(apt_nom), " _(", apt, ")_")
  ) %>%
  select(name_clean, everything())

# VALORISATIONS ----------------------------------------------

figure_plotly <- plot_airport_line(trafic_aeroports,default_airport)

table_airports <- create_table_airports(stats_aeroports)

map_leaflet_airport(pax_apt_all,airports_location,month,year)
