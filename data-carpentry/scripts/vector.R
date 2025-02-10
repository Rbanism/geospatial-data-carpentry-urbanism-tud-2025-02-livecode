library(sf)
library(tidyverse)

delft_boundary <- st_read(here("data", "delft-boundary.shp"))

st_geometry_type(delft_boundary)

st_crs(delft_boundary)
st_crs(delft_boundary)$epsg
st_crs(delft_boundary)$Name

delft_boundary <- st_transform(delft_boundary, crs = 28992)
st_crs(delft_boundary)$Name
st_crs(delft_boundary)$epsg

st_bbox(delft_boundary)
st_crs(delft_boundary)$units_gdal

ggplot(data = delft_boundary) +
  geom_sf(color = "darkblue", fill = "cyan1") +
  labs()

