# helpers.R
# Utility functions used across the analysis pipeline
# ---------------------------------------------------

# Load packages + install if needed + limit messages
load_packages <- function(pkgs) {
  for (p in pkgs) {
    if (!requireNamespace(p, quietly = TRUE)) {
      install.packages(p)
    }
    suppressPackageStartupMessages(
      library(p, character.only = TRUE)
    )
  }
  invisible(NULL)
}



# Pull EHD map data by version, attach ACS total population and people of color 
# counts for the corresponding survey year, and return a cleaned, joined dataset.
# Handles GEOID normalization across V1/V2 (GEOID10) and V3 (CensusTract2020).

pull_EHD_data <- function(ehd_version, acs_year, state = "WA") {
  
  # --- EHD URL lookup ---
  ehd_urls <- list(
    EHDV1 = "https://services8.arcgis.com/rGGrs6HCnw87OFOT/arcgis/rest/services/EHD_Combined_V1/FeatureServer/0",
    EHDV2 = "https://services8.arcgis.com/rGGrs6HCnw87OFOT/arcgis/rest/services/EHD_Combined_V2/FeatureServer/0",
    EHDV3 = "https://services8.arcgis.com/rGGrs6HCnw87OFOT/arcgis/rest/services/Full_Extract_Environmental_Health_Disparities_Map_Version3/FeatureServer/0"
  )
  
  # Validate EHD version argument
  if (!ehd_version %in% names(ehd_urls)) {
    stop(paste("ehd_version must be one of:", paste(names(ehd_urls), collapse = ", ")))
  }
  
  # Parse and validate ACS year
  year_num <- as.integer(gsub("ACS_", "", acs_year))
  if (is.na(year_num)) {
    stop("acs_year must follow the format 'ACS_YYYY' (e.g. 'ACS_2017')")
  }
  
  # --- Pull EHD data ---
  message("Pulling EHD data for ", ehd_version, "...")
  ehd_data <- arc_open(ehd_urls[[ehd_version]]) |> 
    arc_select() |>
    st_drop_geometry()
  
  # --- Normalize GEOID field for V3 ---
  if (ehd_version == "EHDV3") {
    ehd_data <- ehd_data |>
      mutate(GEOID10 = as.character(CensusTract2020)) |>
      select(-CensusTract2020)
  }
  
  # --- Pull ACS data ---
  message("Pulling ACS ", year_num, " 5-year estimates...")
  acs_data <- get_acs(
    geography = "tract",
    variables = c(total_pop = "B03002_001",
                  nh_white  = "B03002_003"),
    state     = state,
    year      = year_num,
    survey    = "acs5",
    output    = "wide"
  ) |>
    transmute(
      GEOID10          = GEOID,
      Total_Population = total_popE,
      People_of_Color  = total_popE - nh_whiteE
    )
  
  # --- Join and filter ---
  result <- ehd_data |>
    left_join(acs_data, by = "GEOID10") |>
    filter(!is.na(Total_Population))
  
  message("Done. ", nrow(result), " tracts returned.")
  return(result)
  
}