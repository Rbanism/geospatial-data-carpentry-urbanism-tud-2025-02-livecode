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

DTM_TUD_df <- as.data.frame(DTM_TUD, xy = TRUE)
DTM_hill_TUD_df <- as.data.frame(DTM_hill_TUD, xy = TRUE)

ggplot() +
geom_raster(data = DTM_TUD_df,
            aes(x = x, y = y,
                fill = `tud-dtm-5m`)) +
geom_raster(data = DTM_hill_TUD_df,
            aes(x = x, y = y,
                alpha = `tud-dtm-5m-hill`)) +
scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) +
coord_equal()

ggplot() +
  geom_raster(data = DTM_TUD_df,
              aes(x = x, y = y,
                  fill = `tud-dtm-5m`)) +
  scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) +
coord_equal()

head(DTM_hill_TUD_df)
str(DTM_hill_TUD_df)

ggplot() +
geom_raster(data = DTM_hill_TUD_df,
            aes(x = x, y = y,
                alpha = `tud-dtm-5m-hill`)) +
  coord_equal()

crs(DTM_TUD, parse = TRUE)
crs(DTM_TUD)

DTM_hill_EPSG28992_TUD <- project(DTM_hill_TUD,
                                  crs(DTM_TUD))

crs(DTM_hill_EPSG28992_TUD, parse = TRUE)

ext(DTM_hill_EPSG28992_TUD)
ext(DTM_TUD)
ext(DTM_hill_TUD)

res(DTM_hill_EPSG28992_TUD)
res(DTM_TUD)

DTM_hill_EPSG28992_TUD <- project(DTM_hill_TUD,
                                  crs(DTM_TUD),
                                  res = res(DTM_TUD))
res(DTM_hill_EPSG28992_TUD)

DTM_hill_TUD_2_df <- as.data.frame(DTM_hill_EPSG28992_TUD, xy = TRUE)

ggplot() +
geom_raster(data = DTM_TUD_df,
            aes(x = x, y = y,
                fill = `tud-dtm-5m`)) +
geom_raster(data = DTM_hill_TUD_2_df,
            aes(x = x, y = y,
                alpha = `tud-dtm-5m-hill`)) +
scale_fill_gradientn(name = "Elevation", colors = terrain.colors(10)) +
  coord_equal()

CHM_TUD <- DSM_TUD - DTM_TUD
CHM_TUD_df <- as.data.frame(CHM_TUD, xy = TRUE)

ggplot() +
  geom_raster(data = CHM_TUD_df,
              aes(x = x, y = y,
                  fill = `tud-dsm-5m`)) +
  scale_fill_gradientn(name = "Canopy Height", colors = terrain.colors(10)) +
  coord_equal()

ggplot(CHM_TUD_df) +
geom_histogram(aes(`tud-dsm-5m`))


custom_bins <- c(-5, 0, 10, 20, 30, 100)
CHM_TUD_df <- CHM_TUD_df %>%
mutate(canopy_discrete = cut(`tud-dsm-5m`, breaks = custom_bins))
ggplot() +
  geom_raster(data = CHM_TUD_df, aes(x =x, y = y,
                                     fill = canopy_discrete)) +
scale_fill_manual(values = terrain.colors(5)) +
  coord_equal()

terra::writeRaster(CHM_TUD,
                   "data_output/CHM_TUD.tiff",
                   filetype = "GTiff",
                   overwrite = TRUE)


describe("data/tudlib-rgb.tif")

RGB_band1_TUD <- rast("data/tudlib-rgb.tif", lyrs = 1)
RGB_band1_TUD_df <- as.data.frame(RGB_band1_TUD, xy = TRUE)

ggplot() +
  geom_raster(data = RGB_band1_TUD_df,
              aes(x = x, y = y,
                  alpha = `tudlib-rgb_1`)) +
  coord_equal()

RGB_stack_TUD <-rast("data/tudlib-rgb.tif")
RGB_stack_TUD

RGB_stack_TUD[[2]]

RGB_stack_TUD_df <- as.data.frame(RGB_stack_TUD, xy = TRUE)
str(RGB_stack_TUD_df)

ggplot() +
geom_raster(data = RGB_stack_TUD_df,
            aes(x = x, y = y,
                alpha = `tudlib-rgb_2`)) +
  coord_equal()

plotRGB(RGB_stack_TUD,
        r = 1, g = 2, b = 3)

plotRGB(RGB_stack_TUD,
        R =1, G=2, B=3)
