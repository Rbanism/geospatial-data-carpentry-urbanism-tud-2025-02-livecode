
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

numeric_vector <- c(1, 3, 5, 8)
numeric_vector

character_vector <- c("Delft", "Amsterdam", "The Hague")
character_vector

character_vector <- c("Delft", "Amsterdam", "'s Gravenhage", '"Big Apple"')
character_vector


str(character_vector)

mixed_vector <- c(numeric_vector, character_vector)
