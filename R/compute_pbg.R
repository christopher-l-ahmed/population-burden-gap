# compute_pbg.R
# Functions to calculate PBG, ΔPBG, and their components (pop-weighted means)
# These metrics quantify changes to the Failure of Distribution (FoD) over time.
# ---------------------------------------------------------------------------------

# Calculate PBG + population-weighted mean burden for group and total population
compute_pbg_components <- function(data, pop_group, pop_total, burden) {
  
  mean_group <- weighted_mean_pop(data, {{ pop_group }}, {{ burden }})
  mean_total <- weighted_mean_pop(data, {{ pop_total }}, {{ burden }})
  
  tibble(
    mean_group = mean_group,
    mean_total = mean_total,
    pbg = mean_group - mean_total
  )
}