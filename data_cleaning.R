library(lubridate)
library(dplyr)
library(purrr)
library(tidyr)
library(tibble)
library(sjPlot)
library(ggplot2)
library(readr)


# Set the base path 
base_path <- "/Users/macbook/Documents/GitHub/WV-Flood-Attendance-Analysis-R/Data"

# Counties to process
counties <- c("Braxton", "Cabell", "Grant", "Jackson")

# --- Attendance Data ---

# Function to read and preprocess data for a given county
process_county_data <- function(county_name, path) {
  county_path <- file.path(path, "Attendance", county_name)
  files <- list.files(path = county_path, pattern = "*.csv", full.names = TRUE)
  
  county_data <- files %>%
    map_df(~ read.csv(.x) %>% 
             mutate(county = county_name, 
                    attendance = as.numeric(gsub("%", "", `Attnd..`))) %>%
             rename(school_year = `School.Year`) %>%
             select(school_year, attendance, county) %>%
             arrange(school_year))
  
  return(county_data)
}

all_attendance_data <- map_df(counties, process_county_data, path = base_path) 
