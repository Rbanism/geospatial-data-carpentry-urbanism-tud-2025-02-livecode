library(tidyverse)
library(terra)
library(here)

describe(here("data-carpentry","data","tud-dsm-5m.tif"))

DSM_TUD <- rast(here("data-carpentry","data","tud-dsm-5m.tif"))
DSM_TUD

summary(DSM_TUD)

summary(values(DSM_TUD))

DSM_TUD_df <- as.data.frame(DSM_TUD, xy = TRUE)
str(DSM_TUD_df)

ggplot() +
geom_raster(data = DSM_TUD_df, aes(x = x, y = y, fill = tud-dsm-5m)) +
scale_fill_viridis_c(option = "turbo") +
  coord_equal()
