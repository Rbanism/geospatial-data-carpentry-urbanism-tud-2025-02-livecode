
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
numbers <- as.numeric(numbers)
str(numbers)



gapminder <- read.csv("data/gapminder_data.csv")

str(gapminder)

head(gapminder)

head(gapminder, 10)

summary(gapminder)

gapminder$country

head(gapminder$country)

gapminder$country <- factor(gapminder$country)

summary(gapminder)

nrow(gapminder)

ncol(gapminder)

library(tidyverse)

year_country_gdp <- select(gapminder, country, year, gdpPercap)

head(year_country_gdp)

year_country_gdp <- gapminder %>%
  select(country, year, gdpPercap)

head(year_country_gdp)

head(select(gapminder, country, year, gdpPercap))



european_countries <- gapminder %>%
  filter(continent == "Europe" & year > 2000)

head(european_countries)

european_countries_selection <- gapminder %>%
  filter(continent == "Europe" & year > 2000) %>%
  select(year, country, gdpPercap)

head(european_countries_selection)

solution_challenge_1 <- gapminder %>%
  filter(continent == "Europe" | continent == "Asia") %>%
  select(lifeExp, country, year)

nrow(solution_challenge_1)

solution_challenge_1 <- gapminder %>%
  filter(continent == "Europe" & continent == "Asia")

nrow(solution_challenge_1)

gapminder %>%
  group_by(continent, year) %>%
  summarize(avg_gdp_per_cap = mean(gdpPercap))

gapminder %>%
  group_by(country) %>%
  count()

# Create a histogram
ggplot(data = gapminder,
        aes(x = lifeExp)) +
  geom_histogram()

p <- gapminder %>%
  filter(year == 2007 & continent == "Americas") %>%
  mutate(country = fct_reorder(country, gdpPercap)) %>% # Re-order factor levels
  ggplot(aes(x = country, y = gdpPercap, fill = lifeExp)) +
  geom_col() +
  coord_flip() +
  scale_fill_viridis_c()

data_americas_2007 <- gapminder %>%
  filter(year == 2007 & continent == "Americas") %>%
  mutate(country = fct_reorder(country, gdpPercap))

write.csv(data_americas_2007,
          here("data_output", "gapminder_data_americas_2007.csv"),
          row.names = FALSE)





ggsave(p, filename = here("fig_output", "plot_americas.png"))







gapminder <- read.csv("data/gapminder_data.csv")

head(gapminder)
