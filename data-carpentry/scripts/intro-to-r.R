
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
mixed_vector
str(mixed_vector)

logical_vector <- c(TRUE, TRUE, FALSE, T, F)
logical_vector
str(logical_vector)

mixed_vector2 <- c(numeric_vector, logical_vector)
mixed_vector2

str(mixed_vector2)


with_na <- c( 1, 4, NA, 6, 5, NA)
with_na

mean(with_na)
mean( with_na, na.rm = TRUE)

is.na(with_na)
!is.na(with_na)

without_na <- with_na[!is.na(with_na)]
without_na


# Factors 

nordic_string <- c("Denmark", "Sweden", "Norway", "Denmark")
nordic_string

nordic_factor <- factor(nordic_string)
nordic_factor

levels(nordic_factor)

summary(nordic_factor)

nordic_factor <- factor( nordic_factor, 
                         levels = c("Sweden", "Norway", "Denmark"))

numbers <- c("1", "2", "3")
str(numbers)
