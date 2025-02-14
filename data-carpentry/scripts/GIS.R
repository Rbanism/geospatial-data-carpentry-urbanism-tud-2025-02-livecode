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
  scale_colour_viridis_c(option = "viridis") +
  coord_sf(datum = st_crs(28992))

# Make the same map for Naarden instead of Brielle.
# Change the name and run all the lines one by one
# OR
#create a function

replication_function <- function(cityname, year=1900){
  bb <- getbb(cityname)

  x <- opq(bbox = bb) %>%
    add_osm_feature(key = 'building') %>%
    osmdata_sf()

  buildings <- x$osm_polygons %>%
    st_transform(.,crs=28992)

  start_date <- as.numeric(buildings$start_date)

  buildings$build_date <- if_else(start_date < year, year, start_date)

  ggplot(data = buildings) +
    geom_sf(aes(fill = build_date, colour=build_date))  +
    scale_fill_viridis_c(option = "viridis")+
    scale_colour_viridis_c(option = "viridis") +
    ggtitle(paste0("Old buildings in ",cityname)) +
    coord_sf(datum = st_crs(28992))

}

replication_function("Brielle, NL")
replication_function("Naarden")


# Challenge
library(leaflet)

buildings2 <- buildings %>%
  st_transform(., st_crs(4326))

leaflet(data = buildings2) %>%
  addTiles() %>%
  addPolygons(fillColor = ~colorQuantile("YlGnBu",
                                         -build_date)(-build_date))

leaflet(buildings2) %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolygons(color = "#444444", weight = 0.1, smoothFactor = 0.5,
              opacity = 0.2, fillOpacity = 0.8,
              fillColor = ~colorQuantile("YlGnBu", -build_date)(-build_date),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE))


# GIS: conservation zone

old <- 1939

buildings$start_date <- as.numeric(buildings$start_date)

old_buildings <- buildings %>%
filter(start_date <= old)

nrow(old_buildings)

ggplot(data = old_buildings) +
geom_sf(colour = "red") +
coord_sf(datum = st_crs(28992))

# Buffer
distance <- 10 # in meters

# First we check that "old buildings" layer projection is in meters
st_crs(old_buildings)

# Create the buffers
buffer_old_buildings <- st_buffer(x = old_buildings,
                                  dist = distance)

ggplot(data = buffer_old_buildings) +
  geom_sf() +
  coord_sf(datum = st_crs(28992))

# Union
single_old_buffer <- st_union(buffer_old_buildings) %>%
  st_cast(to = "POLYGON") %>%
  st_as_sf()

str(single_old_buffer)

single_old_buffer <- single_old_buffer %>%
  mutate("ID" = as.factor(1:nrow(single_old_buffer))) %>%
  st_transform(., crs=28992)

# Centroid
sf::sf_use_s2(FALSE)

centroids_old <- st_centroid(old_buildings) %>%
  st_transform(., crs = 28992)

ggplot() +
  geom_sf(data = single_old_buffer, aes(fill = ID)) +
  geom_sf(data = centroids_old) +
  coord_sf(datum = st_crs(28992))

# Intersection
centroids_buffer <-
  st_intersection(centroids_old, single_old_buffer) %>%
  mutate(n = 1)

str(centroids_buffer)

centroid_by_buffer <- centroids_buffer %>%
  group_by(ID) %>%
  summarise(n = sum(n))

head(centroid_by_buffer)

nrow(single_old_buffer)
single_old_buffer

single_buffer <- single_old_buffer %>%
  mutate(n_buildings = centroid_by_buffer$n)

single_buffer

single_buffer$area <- st_area(single_buffer) %>%
units::set_units(., km^2)

single_buffer$old_buildings_per_km2 <-
  as.numeric(single_buffer$n_buildings / single_buffer$area)

single_buffer

ggplot() +
geom_sf(data = buildings) +
geom_sf(data = single_buffer,
        aes(fill = old_buildings_per_km2), colour = NA) +
scale_fill_viridis_c(alpha = 0.6,
                     begin = 0.6,
                     end = 1,
                     direction = -1,
                     option = "B")

