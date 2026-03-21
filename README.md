# Δ Population Burden Gap (ΔPBG)
This repository contains reproducible R code for calculating the Population Burden Gap (PBG) and its longitudinal counterpart, ΔPBG. The ΔPBG metric tracks changes over time across versions of Environmental Justice (EJ) cumulative impact mapping datasets (using Washington State’s EHD Map as an example).

# The Paper
For the full theoretical framework, including the Failure of Distribution (FoD) lens and the "Equity 2.0" discussion, please see the published paper: (forthcoming)

# The R Code
The analysis is written in R using the tidyverse for maximum readability.

# Citation
If you use this metric or code in your work, please cite the forthcoming paper: (forthcoming)

You can also cite the GitHub repository directly if you want to reference the code itself — the implementation, the workflow, the reproducibility. This is the canonical home of PBG and ΔPBG.

* Christopher Ahmed. (2026). *Population Burden Gap (PBG) and ΔPBG metrics: Reproducible code and analysis*. GitHub repository. https://github.com/christopher-l-ahmed/populatoin-burden-gap


# The Easy Way to Use This GitHub Repository
If you’re newer to GitHub or newer to working with multiple R and Quarto files, this section is for you. I’ll walk you through:

1. The different files in my repository and the tasks they run (at a high level)
2. Why I used several Quarto and R files (instead of one long script)

After that, you'll be ready to start running the R code in this repository with ease!


## <span style="color:#2e6f40;">The Easy Way to Use This GitHub Repository</span>

If you’re newer to GitHub or to working with multiple R and Quarto files, this section is for you. I’ll walk you through:

- the different files in my repository and the tasks they run (at a high level)  
- why I used several Quarto and R files (instead of one long script)

I hope this makes it easier to engage with the R code in this repository.

---

## 📁 R/ — Metric Functions Stored as Separate `.R` Files

This folder contains functions used throughout the analysis.

- `compute_pbg.R` — calculates the Population Burden Gap (PBG)  
- `compute_delta_pbg.R` — calculates the change between two map versions’ PBG values (ΔPBG)  
- `helpers.R` — more functions used to simplify code along the way

You don’t need to edit these files. Instead, Quarto will read them using `source()`.

---

## 📄 analysis/ — Each Major Step Lives in Its Own Quarto File

In ___ (forthcoming paper), I calculate PBG and ΔPBG for three versions of Washington State’s EHD Map. To test how sensitive PBG and ΔPBG are to practical dataset and geography changes, I re‑calculate the metrics under the following hypothetical scenarios:

- **Indicator Stability:** What if the same indicators were always used across versions?  
- **Geographic Stability:** What if census tract boundaries never changed with the 2020 decennial census?  
- **Combined Stability:** What if *both* hypotheticals were true?  

After running these sensitivity analyses, I compare how stable PBG and ΔPBG are across all scenarios.

This repository documents the full workflow behind ___ (forthcoming paper). To keep the script short, readable, and focused, each major part of the analysis is placed in its own Quarto file.

Each Quarto file follows the same workflow:

1. Load libraries  
2. Load the metric functions from the `R/` folder  
3. Load the relevant dataset(s)  
4. Brief comments explaining the purpose of the file  
5. Code that carries out that specific part of the analysis  

The files are organized in the order you should run them:

- `01_baseline.qmd` — calculates PBG and ΔPBG using the three EHD Map versions  
- `02_indicator_stability.qmd` — sensitivity analysis: constant indicators across versions  
- `03_geographic_stability.qmd` — sensitivity analysis: constant tract boundaries  
- `04_combined_stability.qmd` — sensitivity analysis: indicators + boundaries held constant  
- `05_compare_sensitivity.qmd` — compares all sensitivity analyses to the baseline  

You can open and run these files one at a time. Each one is self‑contained.

---

## 🚀 How to Get Started

1. Read the forthcoming paper to understand PBG, ΔPBG, and how to interpret them using the Fairness of Distribution (FoD) framework.  
2. Open `analysis/01_baseline.qmd`.  
3. Run the document from top to bottom.  
4. Move on to the sensitivity files if you want to explore how robust the metrics are.

