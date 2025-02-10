library(sf)
library(tidyverse)

delft_boundary <- st_read(here("data", "delft-boundary.shp"))

st_geometry_type(delft_boundary)

st_crs(delft_boundary)
st_crs(delft_boundary)$epsg
st_crs(delft_boundary)$Name

delst_transform(delft_boundary, crs = 28992)

