# compute_pbg.R
# Functions to calculate PBG, ΔPBG, and their components (pop-weighted means)
# These metrics quantify changes to the Failure of Distribution (FoD) over time.
# ---------------------------------------------------------------------------------

# Population-Weighted Mean --------------------------------------------------------

# Compute a population-weighted mean of a burden variable across census tracts
weighted_mean_pop <- function(data, pop, burden) {
  data |> 
    summarise(wmean = sum({{ pop }} * {{ burden }}) / sum({{ pop }})) |> 
    pull(wmean)
}

# Population Burden Gap -----------------------------------------------------------

# Compute population-weighted mean burden for a group and total population,
# returning their difference as the Population Burden Gap (PBG).
#
# By default, uses all census tracts (full PBG). To compute the extremes
# variant (PBGe), specify ranks or thresholds to isolate concentrated burden.
#
# Arguments:
#   data         : data frame containing tract-level EHD and population data
#   pop_group    : population of interest (e.g. People_of_Color)
#   pop_total    : total population (e.g. Total_Population)
#   burden       : cumulative impact rank or score column
#   extremes     : optional vector of exact ranks (e.g. c(1,2,9,10)) or
#                  two-element threshold vector (e.g. c(0.1, 0.9))
#   extremes_type: "exact" for integer rank scales (default),
#                  "threshold" for continuous scales (e.g. 0-1 or 1-100)
#
# Examples:
#   compute_pbg_components(EHDv1, People_of_Color, Total_Population, EHD_rank)
#   compute_pbg_components(EHDv1, People_of_Color, Total_Population, EHD_rank,
#                          extremes = c(1, 2, 9, 10))
#   compute_pbg_components(EHDv1, People_of_Color, Total_Population, burden_score,
#                          extremes = c(0.1, 0.9), extremes_type = "threshold")
compute_pbg_components <- function(data, pop_group, pop_total, burden, 
                                   extremes = NULL,
                                   extremes_type = c("exact", "threshold")) {
  
  extremes_type <- match.arg(extremes_type)
  
  # Filter to extremes if specified
  if (!is.null(extremes)) {
    burden_col <- as.character(substitute(burden))
    
    if (extremes_type == "exact") {
      data <- data |> filter(.data[[burden_col]] %in% extremes)
    } else if (extremes_type == "threshold") {
      if (length(extremes) != 2) stop("For threshold mode, extremes must be c(low, high)")
      data <- data |> filter(.data[[burden_col]] <= extremes[1] | 
                               .data[[burden_col]] >= extremes[2])
    }
  }
  
  mean_poc   <- weighted_mean_pop(data, {{ pop_group }}, {{ burden }})
  mean_state <- weighted_mean_pop(data, {{ pop_total }}, {{ burden }})
  
  tibble(
    mean_poc   = mean_poc,
    mean_state = mean_state,
    pbg        = mean_poc - mean_state
  )
}