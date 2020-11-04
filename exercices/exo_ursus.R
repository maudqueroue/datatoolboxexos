rm(list = ls())
eco_list <- datatoolboxexos::data_ecoregion()
sp_list <- datatoolboxexos::data_mammals()
sp_eco  <- datatoolboxexos::data_mammals_ecoregions()

library(tidyverse)
ursus <- sp_list %>%
  dplyr::filter(family   == "Ursidae") %>%                       # Sélection des Ursidés
  dplyr::filter(sci_name != "Ursus malayanus") %>%             # Suppression du synonyme
  dplyr::select(species_id, sci_name, common)

## Première jointure
ursus_eco <- ursus %>%
  dplyr::left_join(sp_eco)
## Seconde jointure
ursus_eco <- ursus_eco %>%
  dplyr::left_join(eco_list, by = "ecoregion_id")

## Nombre de royaumes où chaque espèce est retrouvée
realm_ursus <- ursus_eco %>%
  dplyr::group_by(sci_name) %>%
  dplyr::summarise(n_realms     = dplyr::n_distinct(realm))

## Nombre de biomes où chaque espèce est retrouvée
biome_ursus <- ursus_eco %>%
  dplyr::group_by(sci_name) %>%
  dplyr::summarise(n_biomes     = dplyr::n_distinct(biome))

## Nombre d'écorégions où chaque espèce est retrouvée
eco_ursus <- ursus_eco %>%
  dplyr::group_by(sci_name) %>%
  dplyr::summarise(n_ecoregions = dplyr::n_distinct(ecoregion))

## Combinons toutes les informations
realm_ursus %>%
  dplyr::left_join(biome_ursus, by = "sci_name") %>%
  dplyr::left_join(eco_ursus, by = "sci_name") %>%
  dplyr::left_join(ursus, by = "sci_name") %>%
  dplyr::select(sci_name, common, n_realms, n_biomes, n_ecoregions) %>%
  dplyr::arrange(desc(n_ecoregions))
