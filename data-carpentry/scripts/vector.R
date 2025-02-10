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
  labs(title = "Delft Administrative Boundary") +
  coord_sf(datum = st_crs(28992))

lines_Delft <- st_read(here("data", "delft-streets.shp"))
point_Delft <- st_read(here("data", "delft-leisure.shp"))

st_geometry_type(lines_Delft)
st_geometry_type(point_Delft)

st_crs(lines_Delft)
st_crs(point_Delft)

st_bbox(lines_Delft)
st_bbox(point_Delft)

lines_Delft

ncol(lines_Delft)

head(lines_Delft)

head(lines_Delft$highway, 10)
