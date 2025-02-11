library(tidyverse)
library(sf)
library(osmdata)

# define a bounding box
bb <- getbb("Brielle")
bb

# disambigui
bb <- getbb("Brielle, NL")
bb
