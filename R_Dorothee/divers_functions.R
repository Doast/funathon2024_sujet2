create_data_from_input <- function(.data,.an,.mois){
  data <- .data %>% 
    filter(an == .an & mois == .mois)
  return(data)
}

summary_stat_airport <- function(.data){
  stats_aeroport <- .data %>% 
    group_by(apt,apt_nom) %>% 
    summarise(nb_dep = sum(apt_pax_dep),
              nb_tr = sum(apt_pax_tr),
              nb_arr = sum(apt_pax_arr),
              nb_tot = sum(trafic)
    ) %>% 
    arrange(desc(nb_tot)) %>% 
    ungroup()
  
  return(stats_aeroport)
}
