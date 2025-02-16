# WV-Flood-Attendance-Analysis-R

While the financial impact natural disasters is well-documented, I felt there was a gap in understanding the broader, non-market effects. I wanted to explore these less tangible consequences, so I chose to stufy how flooding in West Virginia, a flood-prone state, affects school attendance. This project aims to shed light on these often overlooked impacts.

### Data

My analysis combines attendance data from the WV Department of Education with processed precipitation and flood incident data. Precipitation data (NCEI, 2003-2023) was processed to include only the school year months (September-May) to avoid overestimating flood effects. Flood incidents are counted from FEMA disaster declarations (2003-2023), focusing on flood-realted events during the school year.

### Visual Inspections

A preliminary visual inspection of the data reveals potential insights. The scatterplot of attendance versus percipitation rate (see `attendance_vs_precipitation.png` in the Visualizations repository) shows a relatively flat best-fit line, suggesting a week or non-existent linear relationship. In contrast, plots involving flood incidents counts (also available in the Visualizations repository) appear to show a more pronounced negative relationship with attendance. These visual observations are further investigated through statistical modeling.

### Results

Using precipitation and flood incident counts as indicators of flooding, I found a negative relationship between flood incidents and school attendance. The statistical analysis confirmed the visual observation from `attendacne-vs_precipitation.png` that precipitation along does not have a significant effect. However, the interaction term suggests that higher precipitation levels exacerbate the negative impact of flood incidents on attendance. 

### Why These Results Make Sense

These results are consistent with real-world rationale as high average precipitation over a period might not necessarily indicate a specific flood event impactful enough to affect attendance. Precipitation can be high on average but may not have sufficient cumulative effect at a given time to cause disruption. On the other hand, flood count, as a direct measure of flooding events, is likely a more accurate indicator of actual flood-related disruption.  
