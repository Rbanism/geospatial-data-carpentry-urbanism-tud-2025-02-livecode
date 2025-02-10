
#install.packages("tidyverse")
#install.packages("here")

library(tidyverse) # load tidyverse
library(here)

here()
here("data")

# Assign value 

x <- 40
x

y <- 40/2
y

x + y

x <- y

# Download data 

download.file("https://bit.ly/geospatial_data", 
              here("data", "gapminder_data.csv"))

#Vectors 

