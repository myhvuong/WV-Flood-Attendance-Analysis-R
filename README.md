# WV-Flood-Attendance-Analysis-R

While the financial impact natural disasters is well-documented, I felt there was a gap in understanding the broader, non-market effects. This project examines the relationship between flooding and school attendance in West Virginia, a flood-prone state, using county-level data from four counties.

### Data

My analysis combines attendance data from the WV Department of Education with processed precipitation and flood incident data. Precipitation data (NCEI, 2003-2021) was processed to include only the school year months (September-May) to avoid overestimating flood effects. Flood incidents are counted from FEMA disaster declarations (2003-2021), focusing on flood-realted events during the school year.

### Visual Inspections

A preliminary visual inspection suggests a relatively flat relationship between attendance and precipitation (see `attendance_vs_precipitation.png` in the Visualizations folder), while plots involving flood incident counts (also in the Visualizations folder) suggest a more negative relationship with attendance. These patterns are examined further with regression models.

### Models
All models are estimated with OLS in R (`fixest`) with county fixed effects and heteroskedasticity-robust standard errors. Each is reported with and without school-year fixed effects, because declared floods are rare (only 4 of 72 county-years) and concentrated in 2014-2015, so year fixed effects leave little variation in flooding.

1. Main model: attendance on precipitation (per 100 mm) and flood incidents
2. Robustness check: the main model excluding the 2019-2020 and 2020-2021 (COVID-affected) school years
3. Interaction model: adds a precipitation x flood incidents term
   
### Results

- **Precipitation:** With county and school-year fixed effects, higher average school-year precipitation is associated with slightly higher attendance (about 0.23 percentage points per 100 mm, p < 0.05). This is small and not significant in the county-only specification.
- **Flood incidents:** The flood association is negative and statistically significant with county fixed effects only (about 2.0 percentage points per incident), but not statistically significant once school-year fixed effects are included.
- **Interaction:** With school-year fixed effects, the interaction between precipitation and flood incidents is negative and statistically significant, suggesting the association between flooding and attendance is more negative when precipitation is higher. It is not significant without year fixed effects.
- **COVID robustness:** Excluding the two COVID-affected school years does not change the pattern of statistical significance.
  
### Results Tables

- `table2_main_results.png`
- `table3_robustness_no_covid.png`
- `table4_interaction.png`

### Interpreting the Results

The positive precipitation coefficient is somewhat unexpected. One possible reason is that average September-May precipitation does not distinguish regular rainfall from short periods of intense precipitation, so a wet year is not necessarily a year with more disruptive events. Flood incidents, as a more direct measure of flooding events, may better capture disruption, but the estimate depends on the specification because floods are so rare in the sample.
