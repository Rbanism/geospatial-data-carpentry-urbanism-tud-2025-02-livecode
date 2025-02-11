library(tidyverse)
library(terra)
library(here)

describe(here("data-carpentry","data","tud-dsm-5m.tif"))

DSM_TUD <- rast(here("data-carpentry","data","tud-dsm-5m.tif"))
DSM_TUD

summary(DSM_TUD)

