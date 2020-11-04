---
title: "Exo Ursus"
author: "maud.queroue@gmail.com"
date: "2020-11-04"
output:
  html_document:
    keep_md: yes
---



# Introduction

Dans cet exercice nous allons utiliser le package `dplyr` pour nous instruire sur la biogéographie des ours.

# Données

On utilise la base [**WWF Wildfinder**](https://www.worldwildlife.org/pages/wildfinder-database)

La base de données WildFinder du WWF contient des données de présence/absence pour les amphibiens, reptiles, oiseaux et mammifères terrestres du monde entier au niveau des écorégions terrestres. Seul le sous-ensemble des mammifères est disponible dans ce dépôt avec 4936 espèces. Les données, préalablement nettoyées, sont structurées de la manière suivante dans le dossier `data/wwf-wildfinder/` :

  - `wildfinder-mammals_list.csv` : liste taxonomique des 4936 espèces de mammifères du monde entier
  - `wildfinder-ecoregions_list.csv` : liste des 798 écorégions terrestres définies par le WWF
  - `wildfinder-ecoregions_species.csv` : correspondances entre les espèces et les écorégions

# Analyses

- Histogramme de la distribution du nombre d'espèces de mammifères par écorégion.


```r
#read data
eco_list <- datatoolboxexos::data_ecoregion()
```

```
## Parsed with column specification:
## cols(
##   ecoregion_id = col_character(),
##   ecoregion = col_character(),
##   realm = col_character(),
##   biome = col_character()
## )
```

```r
sp_list <- datatoolboxexos::data_mammals()
```

```
## Parsed with column specification:
## cols(
##   species_id = col_double(),
##   class = col_character(),
##   order = col_character(),
##   family = col_character(),
##   genus = col_character(),
##   species = col_character(),
##   common = col_character(),
##   sci_name = col_character()
## )
```

```r
sp_eco  <- datatoolboxexos::data_mammals_ecoregions()
```

```
## Parsed with column specification:
## cols(
##   ecoregion_id = col_character(),
##   species_id = col_double()
## )
```

```r
library(tidyverse)
```

```
## -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
```

```
## v ggplot2 3.3.2     v purrr   0.3.4
## v tibble  3.0.4     v dplyr   1.0.2
## v tidyr   1.1.2     v stringr 1.4.0
## v readr   1.3.1     v forcats 0.5.0
```

```
## -- Conflicts ------------------------------------------ tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```r
ursus <- sp_list %>%
  dplyr::filter(family   == "Ursidae") %>%                     # Sélection des Ursidés
  dplyr::filter(sci_name != "Ursus malayanus") %>%             # Suppression du synonyme
  dplyr::select(species_id, sci_name, common)

## Première jointure
ursus_eco <- ursus %>%
  dplyr::left_join(sp_eco)
```

```
## Joining, by = "species_id"
```

```r
## Seconde jointure
ursus_eco <- ursus_eco %>%
  dplyr::left_join(eco_list, by = "ecoregion_id")

## Nombre de royaumes où chaque espèce est retrouvée
realm_ursus <- ursus_eco %>%
  dplyr::group_by(sci_name) %>%
  dplyr::summarise(n_realms     = dplyr::n_distinct(realm))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
## Nombre de biomes où chaque espèce est retrouvée
biome_ursus <- ursus_eco %>%
  dplyr::group_by(sci_name) %>%
  dplyr::summarise(n_biomes     = dplyr::n_distinct(biome))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
## Nombre d'écorégions où chaque espèce est retrouvée
eco_ursus <- ursus_eco %>%
  dplyr::group_by(sci_name) %>%
  dplyr::summarise(n_ecoregions = dplyr::n_distinct(ecoregion))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```r
## Combinons toutes les informations
realm_ursus %>%
  dplyr::left_join(biome_ursus, by = "sci_name") %>%
  dplyr::left_join(eco_ursus, by = "sci_name") %>%
  dplyr::left_join(ursus, by = "sci_name") %>%
  dplyr::select(sci_name, common, n_realms, n_biomes, n_ecoregions) %>%
  dplyr::arrange(desc(n_ecoregions))
```

```
## # A tibble: 7 x 5
##   sci_name               common              n_realms n_biomes n_ecoregions
##   <chr>                  <chr>                  <int>    <int>        <int>
## 1 Ursus arctos           Brown Bear                 3       11          139
## 2 Ursus americanus       American Black Bear        3       10           82
## 3 Ursus thibetanus       Asiatic Black Bear         3       11           78
## 4 Helarctos malayanus    Sun Bear                   2        5           37
## 5 Tremarctos ornatus     Spectacled Bear            1        3           23
## 6 Melursus ursinus       Sloth Bear                 1        6           21
## 7 Ailuropoda melanoleuca Giant Panda                1        4            6
```
