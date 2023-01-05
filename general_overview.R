# Objects and functions 
5 + 6
a <- 5
b <- 6
a + b 
sum(a,b)

ages <- c(5, 6)
ages
sum(ages)

names <- c("John", "James")

friends <- data.frame(names, ages)
View(friends)
str(friends)
friends$ages
friends[1,1]
friends[1,]

#Built in datsets to practice
data()
View(CO2)

#Installing and using packages
install.packages("tidyverse")
library(tidyverse)

CO2 %>%
  filter(Treatment == "nonchilled") %>%
  mutate(Cdiv = conc/10) %>%
  select(Cdiv, Plant, Type, Treatment, uptake) %>%
  arrange(Cdiv)

#Explore Data: Data Structure and Types of Variables

View(msleep)
glimpse(msleep)
head(msleep)
class(msleep$name)
length(msleep)
length(msleep$name)
names(msleep)
unique(msleep$vore)
missing <- !complete.cases(msleep)
msleep[missing,]

# Explore Data: Cleaning 
# Select variables
economics %>%
  select(date, unemploy, uempmed)

# CHange variable name
economics %>%
  rename("unemployed" = "unemploy") %>%
  head()

# Filter rows
economics %>%
  select(date, unemploy, uempmed) %>%
  filter(unemploy >= 7000, uempmed >= 8.608)

#Manipulating data
economics %>%
  mutate(uempdays = uempmed*7) %>%
  select(date, unemploy, uempdays)

#Conditional change
economics %>%
  mutate(uempdays = uempmed*7) %>%
  select(date, unemploy, uempdays) %>%
  mutate(length = if_else(uempdays >= 15, "long term", "short term"))

# Reshape data with Pivot wider
View(gapminder)
data <- select(gapminder, country, year, lifeExp)
View(data)

wide_data <- data %>%
  pivot_wider(names_from =  year, values_from = lifeExp )
View(wide_data)

# Reshape data with Pivot longer
long_data <- wide_data %>%
  pivot_longer(2:13, names_to = "year", values_to = "lifeExp" )
View(long_data)

# Describe data: Range and Spread
min(msleep$awake)
max(msleep$awake)
range(msleep$awake)
IQR(msleep$awake)

# Centrality
mean(msleep$awake)
median(msleep$awake)

# Variance
var(msleep$awake)
summary(msleep$awake)
msleep %>%
  select(awake, sleep_total) %>%
  summary()

# Summarize your data
msleep %>%
  drop_na(vore) %>%
  group_by(vore) %>%
  summarize(Lower = min(sleep_total),
            Average = mean(sleep_total),
            Upper = max(sleep_total),
            Difference =
              max(sleep_total)-min(sleep_total)) %>%
  arrange(Average) %>%
  View()

# Create tables
table(msleep$vore)
msleep %>%
  select(vore, order) %>%
  filter(order %in% c("Rodentia", "Primates")) %>%
  table()

# Visualizations
# The grammar of graphics
# data
# mapping
# geometry

# Bar plots
ggplot(data = starwars) + geom_bar(mapping = aes(x = gender))

# Histograms
starwars %>%
  drop_na(height) %>%
  ggplot() + geom_histogram(mapping = aes(x = height))

# Box plots
starwars %>%
  drop_na(height) %>%
  ggplot() + geom_boxplot(aes(height), fill = "steelblue") +
  theme_bw() +
  labs(title = "Boxplot of Height",
       x = "Height of Characters")

# Density plots
starwars %>%
  drop_na(height) %>%
  filter(sex %in% c("male", "female")) %>%
  ggplot() + 
  geom_density(aes(x = height, color = sex, fill = sex), alpha = 1) +
  theme_bw()

# Scatterplots
starwars %>%
  filter(mass < 200) %>%
  ggplot() + geom_point(aes(height, mass, color = sex), size = 5, alpha = 0.5) +
  theme_bw() +
  labs(title = "Height and Mass by Sex")

# Smoothed model
starwars %>%
  drop_na(height, mass, sex) %>%
  filter(mass < 200) %>%
  ggplot(aes(height, mass, color = sex)) +
  geom_point(size = 3, alpha = 0.8) +
  geom_smooth() +
  facet_wrap(~sex) +
  theme_bw() +
  labs(title = "Height and Mass by Sex")

# Analyze 
# Hypothesis testing
# T-Test (compare 2 means)
library(gapminder)
view(gapminder)

#Looking at Africa and Europe: assume that there is no difference in lifeExp = null hypothesis
# Find p-value
gapminder %>%
  filter(continent %in% c("Africa", "Europe")) %>%
  t.test(lifeExp ~ continent, data = ., #put (.) to tell R to put data here
         alternative = "two.sided",
         paired = FALSE)
# P-value = 2.2e-16 (0.00000000000000022) which is less than 0.05, so reject null (there is a stat sig diff)

# ANOVA: Analysis of Variance (3 or more comparisons)
# Looking at Europe, Americas, and Asia
gapminder %>%
  filter(year == 2007) %>%
  filter(continent %in% c("Americas", "Europe", "Asia")) %>%
  aov(lifeExp ~ continent, data = .) %>%
  summary()
# What the P-value is saying is that if the null hypothesis is true (there is no difference), then the p-value is the chance that we'd get a sample that shows differences
gapminder %>%
  filter(year == 2007) %>%
  filter(continent %in% c("Americas", "Europe", "Asia")) %>%
  aov(lifeExp ~ continent, data = .) %>%
  TukeyHSD()
gapminder %>%
  filter(year == 2007) %>%
  filter(continent %in% c("Americas", "Europe", "Asia")) %>%
  aov(lifeExp ~ continent, data = .) %>%
  TukeyHSD() %>%
  plot()

# Chi-squared: for categorical variables
head(iris)
flowers <- iris %>%
  mutate(size = cut(Sepal.Length, 
                    breaks = 3,
                    labels = c("Small", "Medium", "Large"))) %>%
  select(Species, size)

# Chi squared goodness of fit test
flowers %>%
  select(size) %>%
  table() %>%
  chisq.test()

# Chi squared test of independence
flowers %>%
  table() %>%
  chisq.test()

# Linear model
head(cars, 10)
# Call X-axis the Independent Variable (doesn't depend on another variable)
# Call Y-axis the Dependent Variable (depends on another variable)
# In the cars case: X = speed of car, Y = distance taken to stop
# If the slope of the line for x and y was 3.9: for every increase in speed, the distance to stop increases by 3.9
# P-value: null hypothesis is that slope is 0
# R2: how much does y depend on x
cars %>%
  lm(dist ~ speed, data = .) %>%
  summary()

# Rename a column (could also assign to new object) *requires dplyr*
rename(civicscores, scores = Average.scale.score)

# Delete (more like exclude) a column *requires dplyr*
civics %>%
  select(Year, Jurisdiction, scores)























### End of tutorial 2023 ### 
