library(tidyverse)
library(sf)
library(osmdata)

# define a bounding box
bb <- getbb("Brielle")
bb

# disambiguate names
bb <- getbb("Brielle, NL")
bb

x <- opq(bbox = bb) %>%
  add_osm_feature(key = "building") %>%
  osmdata_sf()

str(x$osm_polygons)

# Mapping buildings by date

buildings <- x$osm_polygons %>%
  st_transform(., crs=28992)

str(buildings)

start_date <-as.numeric(buildings$start_date)
buildings$build_date <-if_else(start_date < 1900,
                               1900, start_date)

ggplot(data = buildings) +
  geom_sf(aes(fill = build_date, colour = build_date)) +
  scale_fill_viridis_c(option = "viridis") +


