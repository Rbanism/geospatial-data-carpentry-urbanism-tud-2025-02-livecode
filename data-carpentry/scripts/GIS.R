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
add_osm_feature()
