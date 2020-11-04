#' Extract ursidae
#'
#' @param spdata The data containing all species
#'
#' @return A tibble only containing ursidae
#' @export
#'
extract_ursidae <- function(spdata) {
  ## Sélection des espèces
  spdata %>%
    dplyr::filter(family   == "Ursidae") %>%      # Sélection des Ursidés
    dplyr::filter(sci_name != "Ursus malayanus") %>%   # Suppression du synonyme
    dplyr::select(species_id, sci_name, common)        # Sélection de colonnes
}

#' Join dataframes
#'
#' @param data_ursus The data containing ursidae species
#' @param data_speco The data containing species and ecoregions
#' @param data_eco   The data containing ecoregion info
#'
#' @return A tibble containing ursidae with ecoregion info
#' @export
#'
join_data <- function(data_ursus, data_speco, data_eco) {
  ## Première jointure
  data_ursus %>%
    dplyr::left_join(data_speco) %>%
    ## second
    dplyr::left_join(data_eco, by = "ecoregion_id")
}


#' Get number of ecoregions
#'
#' @param data The joined tibble containing Ursidae species and ecoregion info
#'
#' @return A tibble with number of ecoregions per species of family Ursidae
#' @export
#'
get_necoregions <- function(data) {
  data %>%
    dplyr::group_by(sci_name) %>%
    dplyr::summarise(n_ecoregions = dplyr::n_distinct(ecoregion)) %>%
    dplyr::arrange(dplyr::desc(n_ecoregions))
}

#' Tidy data pantheria
#'
#' @param data The raw pantheria dataset
#'
#' @return A cleaned tibble
#' @export
#'
tidy_pantheria <- function(data) {
  data %>%
    dplyr::mutate(                                    # Conversion de type
      order   = forcats::as_factor(MSW05_Order),
      family  = forcats::as_factor(MSW05_Family)
    ) %>%
    dplyr::rename(                                    # Nom des colonnes
      adult_bodymass = `5-1_AdultBodyMass_g`,
      dispersal_age  = `7-1_DispersalAge_d`,
      gestation      = `9-1_GestationLen_d`,
      homerange      = `22-2_HomeRange_Indiv_km2`,
      litter_size    = `16-1_LittersPerYear`,
      longevity      = `17-1_MaxLongevity_m`
    ) %>%
    dplyr::select(                                    # Sélection de colonnes
      order,
      family,
      adult_bodymass,
      dispersal_age,
      gestation,
      homerange,
      litter_size,
      longevity
    ) %>%
    dplyr::na_if(-999)
}
