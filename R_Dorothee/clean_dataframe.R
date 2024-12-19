#' Nettoyer un dataframe
#'
#' @param dataframe dataframe en entrée
#'
#' @return
#' @export
#'
#' @examples
clean_dataframe <- function(dataframe){
  dataframe <- dataframe %>% 
    mutate(an = str_sub(ANMOIS,1,4),
           mois2 = str_sub(ANMOIS,5,7),
           mois = ifelse(str_sub(mois2,1,1)=="0",str_sub(mois2,2,3),mois2)
    ) %>% 
    select(-mois2)
  colnames(dataframe) <- tolower(colnames(dataframe))
  dataframe
}