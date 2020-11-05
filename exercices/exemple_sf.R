rm(list=ls())

foix        <- c(1.6053807, 42.9638998)
carcassonne <- c(2.3491069, 43.2130358)
rodez       <- c(2.5728419, 44.3516207)

foix        <- sf::st_point(foix)
carcassonne <- sf::st_point(carcassonne)
rodez       <- sf::st_point(rodez)

villes <- sf::st_sfc(
  list(foix, carcassonne, rodez),
  crs = 4326
)
class(villes)

datas <- data.frame(
  ville      = c("Foix", "Carcassonne", "Rodez"),
  population = c(9613, 45895, 23739)
)
villes <- sf::st_sf(datas, geom = villes)
class(villes)

## URL et nom du fichier
url      <- "https://raw.githubusercontent.com/FRBCesab/datatoolbox/master/data/"
filename <- "occitanie_prefectures.csv"

## Téléchargement du fichier
download.file(
  url      = paste0(url, filename),
  destfile = filename
)
## Extraction du ZIP
unzip(zipfile = filename)
(prefectures <- readr::read_csv("occitanie_prefectures.csv"))


prefectures <- sf::st_as_sf(
  x      = prefectures,
  coords = c("longitude", "latitude"),
  crs    = 4326
)
prefectures %>% head(6)

library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)

ggplot(data = world) +
  geom_sf(fill = "#49847b", colour = "#e1ddc0") +
  xlab("Longitude") + ylab("Latitude") + ggtitle("Carte du monde") +
  geom_sf(data = prefectures, colour = "black")

### Puissant trop bien
mapview::mapview(prefectures, col.regions = "#3f3f3f", cex = "population")
