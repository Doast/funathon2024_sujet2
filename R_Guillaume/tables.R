create_table_airports <- function(stats_aeroports){
  
  stats_aeroports_table <- stats_aeroports %>%
    mutate(name_clean = paste0(str_to_sentence(apt_nom), " _(", apt, ")_")
    ) %>%
    select(name_clean, everything())
  
  stats_aeroports_table %>%
    select(-apt, -apt_nom) %>% 
    gt() %>% 
    fmt_number(
      columns = where(is.numeric),
      suffixing = TRUE
    ) %>% 
    fmt_markdown(columns = name_clean) %>% 
    cols_label(
      name_clean = md("**Aéroport**"),
      apt_pax_dep_tot = md("**Départs**"),
      apt_pax_arr_tot = md("**Arrivée**"),
      apt_pax_tr_tot = md("**Transit**"),
      apt_pax_tot = md("**Total**")
    ) %>% 
    tab_header(
      title = md("**Statistiques de fréquentation**"),
      subtitle = md("Classement des aéroports")
    ) %>% 
    tab_style(
      style = cell_fill(color = "powderblue"),
      locations = cells_title()
    ) %>% 
    tab_source_note(source_note = "Données DGAC") %>% 
    opt_interactive()
  
}