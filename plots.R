library(ggplot2)

# Set the base path 
base_path <- "/Users/macbook/Documents/GitHub/WV-Flood-Attendance-Analysis-R/Data"

plot_path <- paste0(sub("/Data", "", base_path), "/Visualizations")

data <- read.csv(paste0(base_path, "/flood_attnd_prcp.csv"))

# Scatter Plot of Attendance vs. Precipitation
p1 <- ggplot(data, aes(x = average_precipitation, y = attendance)) +
  geom_point(alpha = 0.5) +  
  geom_smooth(method = "lm", color = "royalblue4", fill = "royalblue4", se = FALSE) +
  labs(title = "Attendance vs. Precipitation",
       x = "Precipitation (mm)",
       y = "Attendance Rate (%)") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = "white"))

ggsave(filename = paste0(plot_path, "/attendance_vs_precipitation.png"),
       plot = p1, width = 10, height = 6, dpi = 300)

# Scatter Plot of Attendance vs. Count of Flood Incidents
p2 <- ggplot(data, aes(x = flood_incidents, y = attendance)) +
  geom_point(alpha = 0.5) +  
  geom_smooth(method = "lm", color = "royalblue4", fill = "royalblue4", se = FALSE) +
  labs(title = "Attendance vs. Precipitation",
       x = "Precipitation (mm)",
       y = "Attendance Rate (%)") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = "white"))

ggsave(filename = paste0(plot_path, "/attendance_vs_flood_counts.png"),
       plot = p2, width = 10, height = 6, dpi = 300)

# Bar Chart of Average Attendance by County
p3 <- ggplot(data, aes(x = county, y = attendance)) +
  geom_bar(stat = "summary", fun = "mean", fill = "steelblue") +
  labs(title = "Average Attendance by County",
       x = "County",
       y = "Average Attendance Rate (%)") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = "white"))

ggsave(filename = paste0(plot_path, "/average_attendance_by_county.png"), plot = p3, width = 10, height = 6, dpi = 300)

# Line Graph of Attendance Over Time
p4 <- ggplot(data, aes(x = school_year, y = attendance, group = county, color = county)) +
  geom_line() +
  scale_x_discrete(breaks = function(x) unique(x)[c(TRUE, rep(FALSE, 1))]) + # display every second year
  labs(title = "Attendance Over Time by County",
       x = "Year",
       y = "Attendance Rate (%)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + # rotate for readability
  theme(plot.background = element_rect(fill = "white"))

ggsave(filename = paste0(plot_path, "/attendance_over_time_by_county.png"), plot = p4, width = 10, height = 6, dpi = 300)
