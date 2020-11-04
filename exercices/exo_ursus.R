rm(list = ls())
eco_list <- datatoolboxexos::data_ecoregion()
sp_list <- datatoolboxexos::data_mammals()
sp_eco  <- datatoolboxexos::data_mammals_ecoregions()

library(tidyverse)
ursus <- sp_list %>%
  filter(family   == "Ursidae") %>%                       # Sélection des Ursidés
  filter(sci_name != "Ursus malayanus") %>%             # Suppression du synonyme
  select(species_id, sci_name, common)

## Première jointure
ursus_eco <- ursus %>%
  left_join(sp_eco)
## Seconde jointure

ursus_eco <- ursus_eco %>%
  left_join(eco_list, by = "ecoregion_id")

## Nombre de royaumes où chaque espèce est retrouvée
realm_ursus <- ursus_eco %>%
  group_by(sci_name) %>%
  summarise(n_realms     = n_distinct(realm))

## Nombre de biomes où chaque espèce est retrouvée
biome_ursus <- ursus_eco %>%
  group_by(sci_name) %>%
  summarise(n_biomes     = n_distinct(biome))

## Nombre d'écorégions où chaque espèce est retrouvée
eco_ursus <- ursus_eco %>%
  group_by(sci_name) %>%
  summarise(n_ecoregions = n_distinct(ecoregion))

## Combinons toutes les informations
realm_ursus %>%
  left_join(biome_ursus, by = "sci_name") %>%
  left_join(eco_ursus, by = "sci_name") %>%
  left_join(ursus, by = "sci_name") %>%
  select(sci_name, common, n_realms, n_biomes, n_ecoregions) %>%
  arrange(desc(n_ecoregions))
