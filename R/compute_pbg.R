# compute_pbg.R
# Functions to calculate PBG, ΔPBG, and their components (pop-weighted means)
# These metrics quantify changes to the Failure of Distribution (FoD) over time.
# ---------------------------------------------------------------------------------

# Compute a population-weighted mean of a burden variable across census tracts
weighted_mean_pop <- function(data, pop, burden) {
  data |> 
    summarise(wmean = sum({{ pop }} * {{ burden }}) / sum({{ pop }})) |> 
    pull(wmean)
}

# Compute population-weighted mean burden for POC and total population,
# and their difference (PBG)
compute_pbg_components <- function(data, pop_group, pop_total, burden) {
  
  mean_poc   <- weighted_mean_pop(data, {{ pop_group }}, {{ burden }})
  mean_state <- weighted_mean_pop(data, {{ pop_total }}, {{ burden }})
  
  tibble(
    mean_poc   = mean_poc,
    mean_state = mean_state,
    pbg        = mean_poc - mean_state
  )
}