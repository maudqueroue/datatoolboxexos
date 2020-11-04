# rm(list= ls())
# library(tidyverse)

# Read data-------------------------------------
pantheria <- datatoolboxexos::data_pantheria()

# Tidy the dataset---------------------------------
dat <- pantheria %>%
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
  )

dat <- dat %>%
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
  dplyr::na_if(-999)  # Conversion des NA

#Print out---------------------------------------
dat

#Data exploration---------------------------------
#How many observations in order?
dat %>%
  dplyr::count(order)

#How many observations in family?
dat %>%
  dplyr::count(family)

#What is the mean home range by family? Standard deviation? The sample size?
dat %>%
  dplyr::filter(!is.na(homerange)) %>%
  dplyr::group_by(family) %>%
  dplyr::summarise(m = mean(homerange), sd = sd(homerange),n = dplyr::n())

# Graph 1-------------------------------------------
dat %>%
  dplyr::group_by(family) %>% # group by family
  dplyr::mutate(n = dplyr::n()) %>% # calculate number of entries per family
  dplyr::filter(n > 50) %>% # select only the families with more than 100 entries
  ggplot2::ggplot() +
  ggplot2::aes(x = forcats::fct_reorder(family, n), y = n) + # order bars
  ggplot2::geom_col() +
  ggplot2::coord_flip() + # flip the bar chart
  ggplot2::xlab("Family") + # add label for X axis
  ggplot2::ylab("Counts") + # add label for Y axis
  ggplot2::ggtitle("Number of entries per family") # add title

# Graph 2-------------------------------------------
ggplot2::theme_set(ggplot2::theme_bw()) # play around with theme
dat %>%
  dplyr::filter(!is.na(litter_size), !is.na(longevity)) %>%
  dplyr::group_by(family) %>% # group by family
  dplyr::mutate(n = dplyr::n()) %>% # count the number of entries per family
  dplyr::mutate(longevity = longevity / 12) %>% # Change month to year
  dplyr::filter(n > 10) %>% # select only those families with more than 50 entries
  ggplot2::ggplot() +
  ggplot2::aes(x = longevity, y = litter_size, col = family) + # scatter plot
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm", se = FALSE) + # se = TRUE to add confidence intervals
  ggplot2::xlab("Longevity") + # add label for X axis
  ggplot2::ylab("Litter size") + # add label for Y axis
  ggplot2::ggtitle("Scatterplot") + # add title
  ggplot2::facet_wrap(~ family, nrow = 3) # split in several panels,
# one for each family
# remove scale = 'free' for
# same scale for all plots
