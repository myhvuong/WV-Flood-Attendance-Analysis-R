library(dplyr)
library(fixest)

# Read in and prepare data
base_path <- "/Users/macbook/Documents/GitHub/WV-Flood-Attendance-Analysis-R"

data <- read.csv(file.path(base_path, "Data", "/flood_attnd_prcp.csv"))

# One unit increase is an extra 100mm
data <- data %>%
  mutate(precip_100mm = average_precipitation / 1000)

# Summary statistics
summ_table <- tibble(
  Statistic = c("Mean attendance (percentage points)",
                "Mean avg. precipitation (per 100 mm)",
                "County-years with at least one flood incident",
                "Total county-years"),
  Value = c(round(mean(data$attendance, na.rm = TRUE), 2),
            round(mean(data$precip_100mm, na.rm = TRUE), 2),
            sum(data$flood_incidents >= 1, na.rm = TRUE),
            nrow(data))
)

summ_table

# Spec (1)
model1 <- feols(attendance ~ precip_100mm + flood_incidents | county, data = data)
summary(model1, vcov = "hetero")

# Both county and year fixed effects
model1_county_year <- feols(attendance ~ precip_100mm + flood_incidents | county + school_year, data = data)
summary(model1_county_year, vcov = "hetero")

# Robustness check, dropping 2019-2020, and 2020-2021
# Drop COVID-affected school years
data_nocovid <- data %>% filter(!school_year %in% c("2019-2020", "2020-2021"))

model_nocovid_county_year <- feols(attendance ~ precip_100mm + flood_incidents | county + school_year,
                                   data = data_nocovid, vcov = "hetero")
summary(model_nocovid_county_year)

model_nocovid_county <- feols(attendance ~ precip_100mm + flood_incidents | county,
                              data = data_nocovid, vcov = "hetero")
summary(model_nocovid_county)

# Interaction model
model3_county_year <- feols(attendance ~ precip_100mm * flood_incidents | county + school_year,
                            data = data, vcov = "hetero")
summary(model3_county_year)

model3_county <- feols(attendance ~ precip_100mm * flood_incidents | county,
                       data = data, vcov = "hetero")
summary(model3_county)
