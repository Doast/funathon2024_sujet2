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