# Δ Population Burden Gap (ΔPBG)
This repository contains reproducible R code for calculating the Population Burden Gap (PBG) and its longitudinal counterpart, ΔPBG. The ΔPBG metric tracks changes over time across versions of Environmental Justice (EJ) cumulative impact mapping datasets (using Washington State’s EHD Map as an example).

# The Paper
For the full theoretical framework, including the Failure of Distribution (FoD) lens and the "Equity 2.0" discussion, please see the published paper: (forthcoming)

# The R Code
The analysis is written in R using the tidyverse for maximum readability.

# Citation
If you use this metric or code in your work, please cite: (forthcoming)

# The Easy Way to Use This GitHub Repository
If you’re newer to GitHub or newer to working with multiple R and Quarto files, this section is for you. I’ll walk you through:

1. The different files in my repository and the tasks they run (at a high level)
2. Why I used several Quarto and R files (instead of one long script)

After that, you'll be ready to start running the R code in this repository with ease!

## 📁 R/ — Functions are Stored as Seperate .R Files

This folder contains functions used throughout the analysis.

- `compute_pbg.R` — calculates Population Burden Gap (PBG)
- `compute_delta_pbg.R` — calculates the change between two map verions' PBG values (the ΔPBG)
- `helpers.R` — more functions used to simplify code along the way

You don’t need to edit these files. Instead, Quarto will read them using `source()`.

---

## 📄 Quarto/ — Analysis Occurs in Seperate .qmd Quarto Files

In ___ (forthcoming paper), I show to calculate PBG and ΔPBG values and what those values are for the three versions of WA's EHD map. I then re-calculate these values under the following scenarios:

1. What if the same indicators where always used across versions?
2. What if census tract boundaries never changed with the new 2020 deciminal census?
3. What if both these hypothenicals were true?

After conducting this sensitivity analysis I compared how sensitiy PBG and ΔPBG are to these changes. Because this GitHub Repository was amde to doucment my work in that paper, I am including all of my analysis. I could have placed the full analysis in one script, however, to make it easier for the practioner I have placed each major part of the analysis in seperate Quarto documents. The workflow inside each Quarto file follows the same pattern:

1. Load libraries  
2. Load the metric functions from the `R/` folder  
3. Load the relevant dataset(s)  
4. Brief comments explaining the purpose of the file  
5. Code that carries out that specific part of the analysis  

The files are organized in the order you should run them:

- `01_baseline.qmd` — calculates PBG and ΔPBG using the three EHD Map versions  
- `02_sensitivity_1.qmd` — runs sensitivity analysis #1 and recomputes the metrics  
- `03_sensitivity_2.qmd` — sensitivity analysis #2  
- `04_sensitivity_3.qmd` — sensitivity analysis #3  
- `05_compare_sensitivity.qmd` — compares all sensitivity analyses to the baseline  

You can open and run these files one at a time. Each one is self‑contained.

---

## 🚀 How to Get Started

1. Read ___ (paper forthcoming) to understand PBG, ΔPBG, and how to interept them using the Fairness of Distribution (FoD) framework
2. Open `analysis/01_baseline.qmd`  
3. Run the document from top to bottom  
4. Move on to the sensitivity files if you want to explore how robust the metrics are

