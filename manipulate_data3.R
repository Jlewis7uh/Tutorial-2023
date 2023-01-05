# Manipulating "wrangling" data

library(tidyverse)

# View data

glimpse(msleep)

View(msleep)

# Rename a variable

msleep

msleep %>%
  rename("conserv" = "conservation") #("newname" = "oldname")

# Reorder variables

msleep %>%
  select(vore, name, everything()) #Order matters with select, you pick

# Change variable type

class(msleep$vore)

msleep$vore <- as.factor(msleep$vore)

glimpse(msleep)

## In tidyverse

msleep %>%
  mutate(vore = as.character(vore)) %>%
  glimpse()

# Reshaping the data from wide to long or long to wide

library(gapminder)

View(gapminder)

data <- select(gapminder, country, year, lifeExp)

wide_data <- data %>%
  pivot_wider(names_from = year, values_from = lifeExp)

long_data <- wide_data %>%
  pivot_longer(2:13, names_to = "year",
               values_to = "lifeExp")
