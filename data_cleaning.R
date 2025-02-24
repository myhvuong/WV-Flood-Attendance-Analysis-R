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


# --- FEMA Flood Incident Data ---

WV_FEMA_path <- file.path(base_path, "DisasterDeclarationsSummaries.csv")
WV_FEMA <- read.csv(WV_FEMA_path, stringsAsFactors = FALSE) %>%
  filter(state == "WV", incidentType == "Flood") %>%
  mutate(DATE = as.Date(incidentBeginDate)) %>% 
  filter(year(DATE) %in% 2003:2021) %>% 
  filter(!(month(DATE) %in% 6:9)) %>%  # we need to filter for months within a school year
  mutate(designatedArea = gsub(" \\(County\\)", "", designatedArea)) %>% 
  filter(designatedArea %in% counties) %>% 
  count(designatedArea, year = year(DATE)) %>% 
  complete(designatedArea, year, fill = list(n = 0)) %>% 
  rename(flood_incidents = n, county = designatedArea) %>% 
  select(county, year, flood_incidents) 


# --- Merge All Data ---
# Merge precipitation and flood incident data
prcp_flood <- all_precipitation_data %>%
  left_join(WV_FEMA, by = c("county", "year")) %>%
  mutate(flood_incidents = ifelse(is.na(flood_incidents), 0, flood_incidents),
         school_year = paste0(year - 1, "-", year)) %>%
  select(-year)

final_data <- prcp_flood %>%
  full_join(all_attendance_data, by = c("county", "school_year")) %>%
  arrange(county, school_year)

# Export and save the final dataframe
write.csv(final_data, file = paste0(base_path, "/", "flood_attnd_prcp.csv"), row.names = FALSE)
