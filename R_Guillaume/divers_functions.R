create_data_from_input <- function(data, year, month){
  data <- data %>%
    filter(mois %in% month, an %in% year)
  return(data)
}

summary_stat_airport <- function(dataframe){
  
  dataframe %>%
    create_data_from_input(YEARS_LIST, MONTHS_LIST) %>% 
    group_by(apt, apt_nom) %>% 
    summarise(apt_pax_dep_tot = sum(apt_pax_dep, na.rm = T),
              apt_pax_arr_tot = sum(apt_pax_arr, na.rm = T),
              apt_pax_tr_tot = sum(apt_pax_tr, na.rm = T),
              apt_pax_tot = apt_pax_dep_tot + apt_pax_arr_tot + apt_pax_tr_tot
    ) %>% 
    arrange(-apt_pax_tot) %>% 
    ungroup()
  
}