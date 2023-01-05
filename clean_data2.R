# Cleaning Data  

library(tidyverse)

# Variable Types

data()

view(starwars)

glimpse(starwars)

class(starwars$gender)

unique(starwars$gender)

starwars$gender <- as.factor(starwars$gender)

class(starwars$gender)

levels(starwars$gender)

## Change Levels (for scaled category)

starwars$gender <- factor((starwars$gender),
                          levels = c("masculine", "feminine"))
levels(starwars$gender)

# Select Variables

names(starwars)

starwars %>%
  select(name, height, ends_with("color"))

# Filter Observations

starwars %>%
  select(name, height, ends_with("color")) %>%
  filter(hair_color %in% c("blond", "brown") &
           height < 180)

# Missing Data

mean(starwars$height, na.rm = TRUE) 
  