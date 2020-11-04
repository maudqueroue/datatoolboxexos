rm(list= ls())

# Read in data-------------------------------------
pantheria <- datatoolboxexos::data_pantheria()

# Tidy the dataset---------------------------------
dat <- pantheria %>%
  mutate(                                    # Conversion de type
    order   = as_factor(MSW05_Order),
    family  = as_factor(MSW05_Family)
  ) %>%
  rename(                                    # Nom des colonnes
    adult_bodymass = `5-1_AdultBodyMass_g`,
    dispersal_age  = `7-1_DispersalAge_d`,
    gestation      = `9-1_GestationLen_d`,
    homerange      = `22-2_HomeRange_Indiv_km2`,
    litter_size    = `16-1_LittersPerYear`,
    longevity      = `17-1_MaxLongevity_m`
  )

dat <- dat %>%
  select(                                    # Sélection de colonnes
    order,
    family,
    adult_bodymass,
    dispersal_age,
    gestation,
    homerange,
    litter_size,
    longevity
  ) %>%
  na_if(-999)  # Conversion des NA

#Data exploration---------------------------------
#How many observations in order?
dat %>%
  count(order)

#How many observations in family?
dat %>%
  count(family)

#What is the mean home range by family? Standard deviation? The sample size?
dat %>%
  filter(!is.na(homerange)) %>%
  group_by(family) %>%
  summarise(m = mean(homerange), sd = sd(homerange),n = n())

# Graph 1-------------------------------------------
dat %>%
  group_by(family) %>% # group by family
  mutate(n = n()) %>% # calculate number of entries per family
  filter(n > 50) %>% # select only the families with more than 100 entries
  ggplot() +
  aes(x = fct_reorder(family, n), y = n) + # order bars
  geom_col() +
  coord_flip() + # flip the bar chart
  xlab("Family") + # add label for X axis
  ylab("Counts") + # add label for Y axis
  ggtitle("Number of entries per family") # add title

# Graph 2-------------------------------------------
theme_set(theme_bw()) # play around with theme
dat %>%
  filter(!is.na(litter_size), !is.na(longevity)) %>%
  group_by(family) %>% # group by family
  mutate(n = n()) %>% # count the number of entries per family
  mutate(longevity = longevity / 12) %>% # Change month to year
  filter(n > 10) %>% # select only those families with more than 50 entries
  ggplot() +
  aes(x = longevity, y = litter_size, col = family) + # scatter plot
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) + # se = TRUE to add confidence intervals
  xlab("Longevity") + # add label for X axis
  ylab("Litter size") + # add label for Y axis
  ggtitle("Scatterplot") + # add title
  facet_wrap(~ family, nrow = 3) # split in several panels,
# one for each family
# remove scale = 'free' for
# same scale for all plots
