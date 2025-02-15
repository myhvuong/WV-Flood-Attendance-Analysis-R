# Read in and prepare data
base_path <- "/Users/macbook/Documents/GitHub/WV-Flood-Attendance-Analysis-R"

data <- read.csv(file.path(base_path, "Data", "/flood_attnd_prcp.csv"))

data <- data %>% 
  mutate(county = as.factor(county),
                        school_year = as.factor(school_year)) %>%
  rename(`Flood Incidents` = flood_incidents,
         Precipitation = average_precipitation,
         Attendance = attendance,
         County = county,
        `School Year` = school_year)


# Linear regression model with county fixed effects
model1 <- lm(Attendance ~ Precipitation + `Flood Incidents` + County, data = data)

# Linear regression model with no county fixed effects
model2 <- lm(Attendance ~ Precipitation + `Flood Incidents`, data = data)

# Linear regression model with interaction term and county fixed effects
model3 <- lm(Attendance ~ Precipitation:`Flood Incidents` + County, data = data)


tab_model(model1, file = output_file1)
tab_model(model2, file = output_file2)
tab_model(model3, file = output_file3)
