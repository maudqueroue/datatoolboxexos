
#' Get ecoregion data
#'
#' @return data.frame with info on ecoregions
#' @export
#'
data_ecoregion <- function() {

  readr::read_csv(here::here("data", "wwf-wildfinder", "wildfinder-ecoregions_list.csv"))

}

#' Get mammal species data
#'
#' @return data.frame with info on mammals
#' @export
#'
data_mammals <- function() {

  readr::read_csv(here::here("data", "wwf-wildfinder", "wildfinder-mammals_list.csv"))

}

#' Get mammals <-> ecoregions data
#'
#' @return data.frame with info on which mammals in ecoregions
#' @export
#'
data_mammals_ecoregions <- function() {

  readr::read_csv(here::here("data", "wwf-wildfinder", "wildfinder-ecoregions_species.csv"))

}
