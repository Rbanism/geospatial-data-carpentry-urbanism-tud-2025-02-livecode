library(tidyverse)
library(terra)
library(here)

describe("data/tud-dsm-5m.tif")

DSM_TUD <- rast("data/tud-dsm-5m.tif")
DSM_TUD

summary(DSM_TUD)

summary(values(DSM_TUD))

DSM_TUD_df <- as.data.frame(DSM_TUD, xy = TRUE)
str(DSM_TUD_df)

ggplot() +
geom_raster(data = DSM_TUD_df, aes(x = x, y = y, fill = `tud-dsm-5m`)) +
scale_fill_viridis_c(option = "turbo") +
  coord_equal()

crs(DSM_TUD, proj = TRUE)

minmax(DSM_TUD)

DSM_TUD <- setMinMax(DSM_TUD)
minmax(DSM_TUD)

min(values(DSM_TUD))
max(values(DSM_TUD))

nlyr(DSM_TUD)

describe("data/tud-dsm-5m-hill.tif")

DSM_TUD_df <- DSM_TUD_df %>%
  mutate(fct_elevation = cut(`tud-dsm-5m`, breaks = 3))

ggplot() +
geom_bar(data = DSM_TUD_df, aes(fct_elevation))

custom_bins <- c(-10, 0, 5, 100)

DSM_TUD_df <- DSM_TUD_df %>%
  mutate(fct_elevation_cb = cut(`tud-dsm-5m`, breaks = custom_bins))

levels(DSM_TUD_df$fct_elevation_cb)

head(DSM_TUD_df)

ggplot() +
geom_bar(data = DSM_TUD_df, aes(fct_elevation_cb))

ggplot() +
geom_raster(data = DSM_TUD_df, aes(x = x, y = y, fill = fct_elevation_cb)) +
  coord_equal()

my_col <- terrain.colors(3)

ggplot() +
geom_raster(data = DSM_TUD_df, aes( x = x, y = y , fill = fct_elevation_cb)) +
scale_fill_manual(values = my_col, name = "Elevation") +
  coord_equal()

ggplot() +
geom_raster(data = DSM_TUD_df, aes(x = x, y = y, fill = fct_elevation_cb)) +
  scale_fill_manual(values = my_col, name = "Elevation") +
  theme(axis.title = element_blank()) +
coord_equal()

DTM_TUD <- rast("data/tud-dtm-5m.tif")
DTM_hill_TUD <- rast("data/tud-dtm-5m-hill-WGS84.tif")

DTM_TUD_df <- as.data.frame(DTM_TUD)
DTM_hill_TUD_df <- as.data.frame(DTM_hill_TUD)

gpplot() +
geom_raster(data = )
