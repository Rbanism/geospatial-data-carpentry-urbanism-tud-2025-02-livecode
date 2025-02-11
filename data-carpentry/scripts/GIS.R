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

old <- 1800

buildings$start_date <- as.numeric(buildings$start_date)

old_buildings <- buildings %>%
filter(start_date <= old)

nrow(old_buildings)

ggplot(data = old_buildings) +
geom_sf(colour = "red") +
coord_sf(datum = st_crs(28992))

# Buffer
distance <- 100 # in meters

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
