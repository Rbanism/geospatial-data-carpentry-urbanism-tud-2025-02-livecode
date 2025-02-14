# Load packages
library(sf)
library(tidyverse)

# Read data - Delft boundary
delft_boundary <- st_read(here("data", "delft-boundary.shp"))

# Examining the data
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

# Challenge 1 - Read and examine lines and point data
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

unique(lines_Delft$highway)

lines_Delft$highway <- factor(lines_Delft$highway)

str(lines_Delft)

# Extract cycleways from Delft streets
cycleway_Delft <- lines_Delft %>%
  filter(highway == "cycleway")

nrow(lines_Delft)
nrow(cycleway_Delft)
levels(cycleway_Delft$highway)
unique(cycleway_Delft$highway)

# Calculate total length of cycleways in Delft
cycleway_Delft <- cycleway_Delft %>%
  mutate(length = st_length(.))

head(cycleway_Delft)

cycleway_Delft %>%
  summarise(total_length = sum(length))

ggplot(data = cycleway_Delft) +
  geom_sf() +
  labs(title = "Slow mobility network in Delft",
       subtitle = "Cycleways") +
  coord_sf(datum = st_crs(28992))

# Challenge 2 - repeat with motorways
motorway_Delft <- lines_Delft %>%
  filter(highway == "motorway")

motorway_Delft_summary <- motorway_Delft %>%
  mutate(length = st_length(.)) %>%
  # select(everything(), geometry) %>%
  summarise(total_length = sum(length))

nrow(motorway_Delft)

ggplot(data = motorway_Delft) +
  geom_sf(size = 1.5) +
  ggtitle("Mobility network of Delft", subtitle = "Motorways") +
  coord_sf(datum = st_crs(28992))

st_geometry_type(motorway_Delft_summary)

# Subset road types and plot them with custom colors
road_types <- c("motorway", "primary", "secondary", "cycleway")

lines_Delft_selection <- lines_Delft %>%
  filter(highway %in% road_types) %>%
  mutate(highway = factor(highway, levels = road_types))

str(lines_Delft_selection)

road_colors <- c("blue", "green", "navy", "purple")

ggplot(data = lines_Delft_selection) +
  geom_sf(aes(color = highway)) +
  scale_color_manual(values = road_colors) +
  labs(title = "Mobility network in Delft",
       subtitle = "Main roads & cicyleways",
       color = "Road Type") +
  coord_sf(datum = st_crs(28992))

# Plot multiple layers
ggplot() +
  geom_sf(data = delft_boundary,
          fill = "lightgrey",
          color = "lightgrey") +
  geom_sf(data = lines_Delft_selection,
          aes(color = highway)) +
  geom_sf(data = point_Delft) +
  labs(title = "Mobility networks of Delft") +
  coord_sf(datum = st_crs(28992))

point_Delft

point_Delft <- point_Delft %>%
  mutate(leisure = factor(leisure))
str(point_Delft)

levels(point_Delft$leisure)

leisure_colors <- rainbow(15)
leisure_colors

ggplot() +
  geom_sf(data = delft_boundary,
          fill = "lightgrey",
          color = "lightgrey") +
  geom_sf(data = lines_Delft_selection,
          aes(color = highway)) +
  geom_sf(data = point_Delft,
          aes(fill = leisure),
          shape = 21) +
  scale_color_manual(values = road_colors,
                     name = "Road Type") +
  scale_fill_manual(values = leisure_colors,
                    name = "Leisure Location") +
  labs(title = "Mobility network and leisure in Delft") +
  coord_sf(datum = st_crs(28992))

# Challenge
point_Delft_selection <- point_Delft %>%
  filter(leisure %in% c("playground", "picnic_table"))

blue_orange <- c("cornflowerblue", "darkorange")

ggplot() +
  geom_sf(data = lines_Delft_selection,
          aes(color = highway)) +
  geom_sf(data = point_Delft_selection,
          aes(fill = leisure, shape = leisure)) +
  scale_shape_manual(name = "Leisure Type", values = c(21, 22)) +
  scale_color_manual(name = "Road Type", values = road_colors) +
  scale_fill_manual(name = "Leisure Type", values = blue_orange) +
  labs(title = "Road network and leisure") +
  coord_sf(datum = st_crs(28992))


# Handling spatial projections
municipal_boundary_NL <- st_read(here("data", "nl-gemeenten.shp"))

ggplot() +
  geom_sf(data = municipal_boundary_NL) +
  labs(title = "Map of Contiguous NL Municipal Boundaries") +
  coord_sf(datum = st_crs(28992))

country_boundary_NL <- st_read(here("data", "nl-boundary.shp"))

ggplot() +
  # geom_sf(data = country_boundary_NL,
  #         color = "gray18",
  #         linewidth = 2) +
  geom_sf(data = municipal_boundary_NL,
          color = "gray40") +
  labs(title = "Map of Contiguous NL Municipal Boundaries") +
  coord_sf(datum = st_crs(28992))

boundary_Delft <- st_read(here("data", "delft-boundary.shp"))

ggplot() +
  geom_sf(data = municipal_boundary_NL,
          color = "gray40") +
  geom_sf(data = boundary_Delft,
          color = "purple",
          fill = "purple")

st_crs(municipal_boundary_NL)$epsg
st_crs(boundary_Delft)$epsg

# Challenge
str(municipal_boundary_NL)
unique(municipal_boundary_NL$ligtInPr_1)

boundary_ZH <- municipal_boundary_NL %>%
  filter(ligtInPr_1 == "Zuid-Holland")

ggplot() +
  geom_sf(data = boundary_ZH,
          aes(color = "color"), show.legend = "line") +
  scale_color_manual(name = "",
                     labels = "Municipal Boundaries in South Holland",
                     values = c("color" = "gray18")) +
  geom_sf(data = boundary_Delft,
          aes(shape = "shape"),
          color = "purple",
          fill = "purple") +
  scale_shape_manual(name = "",
                     labels = "Municipality of Delft",
                     values = c("shape" = 19)) +
  labs(title = "Delft location") +
  # theme(legend.background = element_rect(color = NA)) +
  coord_sf(datum = st_crs(28992))

# Write vector data to file
st_write(point_Delft_selection,
         here("data_output", "leisure_location_selection.shp"),
         driver = "ESRI Shapefile")






