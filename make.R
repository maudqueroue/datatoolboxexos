###################################################
#
# Data and Code for the CESAB Datatoolbox Exercices
#
###################################################

# ----- clean workspace
rm(list = ls())

# ----- install/update packages
devtools::install_deps()

# ----- install compendium package
devtools::load_all()

# ----- Knit exo dplyr
#rmarkdown::render(here::here("exercices","exo_dplyr.Rmd"))

#------ drake
## Execute plan
drake::r_make()
## Visualize
drake::r_vis_drake_graph(targets_only = TRUE)
drake::r_vis_drake_graph()
