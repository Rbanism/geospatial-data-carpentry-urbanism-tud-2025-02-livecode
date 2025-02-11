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




