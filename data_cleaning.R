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


# --- Precipitation Data ---

# Function to process precipitation data 
process_precip_data <- function(county_name, data_path) {
  files <- list.files(path = data_path, pattern = "*.csv", full.names = TRUE, recursive = FALSE)
  
  county_data <- lapply(files, function(file_path) {
    read.csv(file_path, stringsAsFactors = FALSE) %>%
      select(DATE, PRCP) %>%
      
      # Creating a column that is 4 months later
      # this helps filter data that falls within a school year (Sep-May)
      mutate(DATE = as.Date(DATE),
             LATERDATE = DATE %m+% months(4)) %>% 
      
      # LATERDATE 1-9 should indicate Sept through May 
      filter(month(LATERDATE) %in% 1:9) %>%
      
      # LATERDATE = 2004 is equivalent to school year 2003-2004
      filter(year(LATERDATE) %in% 2004:2021) %>%
      mutate(year = year(LATERDATE)) %>%
      group_by(year) %>%
      summarise(prcp = sum(PRCP, na.rm = TRUE), .groups = "drop") %>% 
      mutate(county = county_name)
  }) %>%
    bind_rows() %>%
    group_by(year, county) %>%
    summarise(average_precipitation = mean(prcp, na.rm = TRUE), .groups = "drop") %>% 
    select(county, year, average_precipitation)
  
  return(county_data) 
}

data_paths <- setNames(file.path(base_path, counties), counties) 

all_precipitation_data <- imap(data_paths, ~ process_precip_data(.y, .x)) %>% 
  bind_rows()
