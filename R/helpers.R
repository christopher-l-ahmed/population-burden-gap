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

