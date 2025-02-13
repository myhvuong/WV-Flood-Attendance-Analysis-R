library(ggplot2)

# Set the base path 
base_path <- "/Users/macbook/Documents/GitHub/WV-Flood-Attendance-Analysis-R/Data"

data <- read.csv(paste0(base_path, "/flood_attnd_prcp.csv"))

# Scatter Plot of Attendance vs. Precipitation
p1 <- ggplot(data, aes(x = average_precipitation, y = attendance)) +
  geom_point(alpha = 0.5) +  # Use semi-transparent points
  labs(title = "Attendance vs. Precipitation",
       x = "Precipitation (mm)",
       y = "Attendance Rate (%)") +
  theme_minimal()

# Bar Chart of Average Attendance by County
p2 <- ggplot(data, aes(x = county, y = attendance)) +
  geom_bar(stat = "summary", fun = "mean", fill = "steelblue") +
  labs(title = "Average Attendance by County",
       x = "County",
       y = "Average Attendance Rate (%)") +
  theme_minimal()

# Line Graph of Attendance Over Time
p3 <- ggplot(data, aes(x = school_year, y = attendance, group = county, color = county)) +
  geom_line() +
  scale_x_discrete(breaks = function(x) unique(x)[c(TRUE, rep(FALSE, 1))]) + # display every second year
  labs(title = "Attendance Over Time by County",
       x = "Year",
       y = "Attendance Rate (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # rotate for readability
