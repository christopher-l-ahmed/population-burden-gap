# helpers.R
# Utility functions used across the analysis pipeline
# ---------------------------------------------------

# Library Load/Install -----------------------------------------------------------

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

# EHD Data Pull ------------------------------------------------------------------

# Pull EHD map data by version, attach ACS total population and people of color
# counts for the corresponding survey year, and return a cleaned, standardized
# dataset with consistent field names across all three versions.
# Geometry is dropped — PBG calculation is purely numeric.
# V3 additional indicators not present in V1/V2 are excluded to support
# consistent longitudinal comparison. See crosswalk in documentation for
# full variable mapping across versions.
# Handles GEOID normalization across V1/V2 (GEOID10) and V3 (CensusTract2020).

pull_EHD_data <- function(ehd_version, acs_year, state = "WA") {
  
  # --- EHD URL lookup ---
  ehd_urls <- list(
    EHDV1 = "https://services8.arcgis.com/rGGrs6HCnw87OFOT/arcgis/rest/services/EHD_Combined_V1/FeatureServer/0",
    EHDV2 = "https://services8.arcgis.com/rGGrs6HCnw87OFOT/arcgis/rest/services/EHD_Combined_V2/FeatureServer/0",
    EHDV3 = "https://services8.arcgis.com/rGGrs6HCnw87OFOT/arcgis/rest/services/Full_Extract_Environmental_Health_Disparities_Map_Version3/FeatureServer/0"
  )
  
  # --- Field rename maps (new_name = "old_name") ---
  rename_maps <- list(

    EHDV1 = c(
      GEOID10                   = "GEOID10",
      DieselEmissions           = "Diesel_Emissions",
      DieselEmissions_Rank      = "Diesel_Emissions_IBL_Rank",
      Ozone_Concentration       = "Ozone_Concentration",
      Ozone_Concentration_Rank  = "Ozone_Concentration_IBL_Rank",
      PM2_5                     = "PM2_5",
      PM2_5_Rank                = "PM2_5_IBL_Rank",
      Heavy_Traffic_Proximity   = "Populations_near_Heavy_Traffic_",
      Heavy_Traffic_Rank        = "Heavy_Traffic_IBL_Rank",
      RSEI                      = "RSEI",
      RSEI_Rank                 = "RSEI_IBL_Rank",
      Lead_Risk_Housing         = "Percent_Lead_Risk_from_Housing",
      Lead_Risk_Rank            = "Lead_Risk_IBL_Rank",
      TSDFs                     = "TSDFs",
      TSDFs_Rank                = "TSDF_IBL_Rank",
      PNPL                      = "PNPL",
      PNPL_Rank                 = "PNPL_IBL_Rank",
      PRMP                      = "PRMP",
      PRMP_Rank                 = "PRMP_IBL_Rank",
      Wastewater_Discharge      = "Wastewater_Discharge",
      Wastewater_Rank           = "Wastewater_Discharge_IBL_Rank",
      LEP                       = "LEP",
      LEP_Rank                  = "LEP_IBL_Rank",
      No_HS_Diploma             = "Percent_NHSD",
      No_HS_Diploma_Rank        = "NHSD_IBL_Rank",
      Percent_POC               = "Percent_POC",
      POC_Rank                  = "POC_IBL_Rank",
      Poverty_Rate              = "Percent_Poverty",
      Poverty_Rank              = "Poverty_IBL_Rank",
      Transportation_Expense    = "Transportation_Expense",
      Transportation_Rank       = "Transportation_IBL_Rank",
      Unaffordable_Housing      = "Unaffordable_Housing",
      Unaffordable_Housing_Rank = "Unaffordable_Housing_IBL_Rank",
      Unemployment_Rate         = "Percent_Unemployed",
      Unemployment_Rank         = "Unemployed_IBL_Rank",
      CVD_Death                 = "CVD_Death",
      CVD_Rank                  = "CVD_IBL_Rank",
      Low_Birth_Weight          = "Percent_LBW",
      Low_Birth_Weight_Rank     = "LBW_IBL_Rank",
      Env_Exposure_Theme_Rank   = "Env_Exposure_Theme_Rank",
      Env_Effects_Theme_Rank    = "Env_Effects_Theme_Rank",
      Socioeconomic_Theme_Rank  = "Socioeconomic_Theme_Rank",
      Sensitive_Pop_Theme_Rank  = "Sensitive_Pop_Theme_Rank",
      EHD_Rank                  = "Environmental_Health_Disparites"
    ),
    
    EHDV2 = c(
      GEOID10                   = "GEOID10",
      DieselEmissions           = "Diesel_PM2_5_Emissions",
      DieselEmissions_Rank      = "Diesel_Rank",
      Ozone_Concentration       = "Ozone_Concentration",
      Ozone_Concentration_Rank  = "Ozone_Rank",
      PM2_5                     = "PM2_5",
      PM2_5_Rank                = "PM2_5_Rank",
      Heavy_Traffic_Proximity   = "Proximity_to_Heavy_Traffic_Road",
      Heavy_Traffic_Rank        = "Proximity_to_Heavy_Traffic_Ro_1",
      RSEI                      = "Toxic_Release_from_Facilities__",
      RSEI_Rank                 = "RSEI_Rank",
      Lead_Risk_Housing         = "Lead_Risk_from_Housing",
      Lead_Risk_Rank            = "Lead_Risk_Rank",
      TSDFs                     = "PTSDFs",
      TSDFs_Rank                = "PTSDF_Rank",
      PNPL                      = "PNPL",
      PNPL_Rank                 = "PNPL_Rank",
      PRMP                      = "PRMP",
      PRMP_Rank                 = "PRMP_Rank",
      Wastewater_Discharge      = "PWDIS",
      Wastewater_Rank           = "WDIS_Rank",
      LEP                       = "LEP",
      LEP_Rank                  = "LEP_Rank",
      No_HS_Diploma             = "No_HS_Diploma",
      No_HS_Diploma_Rank        = "No_HS_Diploma_Rank",
      Percent_POC               = "POC",
      POC_Rank                  = "POC_Rank",
      Poverty_Rate              = "Poverty",
      Poverty_Rank              = "Poverty_Rank",
      Transportation_Expense    = "Transportation_Expense",
      Transportation_Rank       = "Transportation_Expense_Rank",
      Unaffordable_Housing      = "Unaffordable_Housing",
      Unaffordable_Housing_Rank = "Unaffordable_Housing_Rank",
      Unemployment_Rate         = "Unemployed",
      Unemployment_Rank         = "Unemployed_Rank",
      CVD_Death                 = "CVD",
      CVD_Rank                  = "CVD_Rank",
      Low_Birth_Weight          = "LBW",
      Low_Birth_Weight_Rank     = "LBW_Rank",
      Env_Exposure_Theme_Rank   = "Environmental_Exposures_Theme_R",
      Env_Effects_Theme_Rank    = "Environmental_Effects_Theme_Ran",
      Socioeconomic_Theme_Rank  = "Socioeconomic_Factors_Theme_Ran",
      Sensitive_Pop_Theme_Rank  = "Sensitive_Populations_Theme_Ran",
      EHD_Rank                  = "Environmental_Health_Disparitie"
    ),
    
    EHDV3 = c(
      GEOID10                   = "GEOID10",
      # Note: V3 combined Diesel and RSEI into one measure (Diesel_AirToxics).
      # For V1-style reconstruction, this combined measure is mapped to
      # DieselEmissions only. RSEI is excluded from V3 reconstruction.
      # This reduces Environmental Exposures theme by one indicator for V3.
      # See paper methods for full discussion.
      DieselEmissions           = "Diesel_AirToxics",
      DieselEmissions_Rank      = "Diesel_AirToxics_Rank",
      Ozone_Concentration       = "Ozone",
      Ozone_Concentration_Rank  = "Ozone_Rank",
      PM2_5                     = "PM2_5",
      PM2_5_Rank                = "PM2_5_Rank",
      Heavy_Traffic_Proximity   = "Heavy_Traffic_Roadways",
      Heavy_Traffic_Rank        = "Heavy_Traffic_Roadways_Rank",
      Lead_Risk_Housing         = "Lead_Risk",
      Lead_Risk_Rank            = "Lead_Risk_Rank",
      TSDFs                     = "Hazardous_Waste",
      TSDFs_Rank                = "Hazardous_Waste_Rank",
      PNPL                      = "Superfund_Sites",
      PNPL_Rank                 = "Superfund_Sites_Rank",
      PRMP                      = "Risk_Management_Plan",
      PRMP_Rank                 = "Risk_Management_Plan_Rank",
      Wastewater_Discharge      = "Wastewater_Discharge",
      Wastewater_Rank           = "Wastewater_Discharge_Rank",
      LEP                       = "Primary_Language",
      LEP_Rank                  = "Primary_Language_Rank",
      No_HS_Diploma             = "No_HS_Diploma",
      No_HS_Diploma_Rank        = "No_HS_Diploma_Rank",
      Percent_POC               = "POC",
      POC_Rank                  = "POC_Rank",
      Poverty_Rate              = "Poverty",
      Poverty_Rank              = "Poverty_Rank",
      Transportation_Expense    = "Transportation_Expense",
      Transportation_Rank       = "Transportation_Expense_Rank",
      Unaffordable_Housing      = "Unaffordable_Housing",
      Unaffordable_Housing_Rank = "Unaffordable_Housing_Rank",
      Unemployment_Rate         = "Unemployment",
      Unemployment_Rank         = "Unemployment_Rank",
      CVD_Death                 = "CardiovascularDisease",
      CVD_Rank                  = "CardiovascularDisease_Rank",
      Low_Birth_Weight          = "LowBirthWeight",
      Low_Birth_Weight_Rank     = "LowBirthWeight_Rank",
      Env_Exposure_Theme_Rank   = "Environmental_Exposures_Theme",
      Env_Effects_Theme_Rank    = "Environmental_Effects_Theme",
      Socioeconomic_Theme_Rank  = "Socioeconomic_Factors_Theme",
      Sensitive_Pop_Theme_Rank  = "Sensitive_Populations_Theme",
      EHD_Rank                  = "Cumulative_EHD_Rank"
    )
  )
  
  # --- Validate EHD version argument ---
  if (!ehd_version %in% names(ehd_urls)) {
    stop(paste("ehd_version must be one of:", paste(names(ehd_urls), collapse = ", ")))
  }
  
  # --- Parse and validate ACS year ---
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
  
  # --- Validate all expected fields are present before renaming ---
  rename_map <- rename_maps[[ehd_version]]
  missing_fields <- setdiff(unname(rename_map), names(ehd_data))
  if (length(missing_fields) > 0) {
    stop(paste("The following expected fields are missing from the EHD data pull:\n",
               paste(missing_fields, collapse = "\n ")))
  }
  
  # --- Rename and select standardized fields ---
  ehd_data <- ehd_data |>
    rename(all_of(rename_map)) |>
    select(all_of(names(rename_map)))
  
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