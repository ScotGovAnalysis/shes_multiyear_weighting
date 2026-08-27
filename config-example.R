################################################################
# config.R
#
# Scottish Health Survey (SHeS) Multi-year Weighting RAP
#
# Purpose
# 
# Central configuration file for the weighting process.
#
# This is the only file that should normally require updating
# when producing weights for a new survey year.
#
# Contents
# 
# * Year combinations to be processed
# * Reference year specification
# * Weight variables required for final outputs
# * Population totals
# * Input file locations
# * Calibration totals file locations
# * Shared file paths
#
# Updating for a new survey year
# 
# The following sections should be reviewed and updated:
#
# 1. config$years
#    Add the new survey year.
#
# 2. config$year_runs
#    Add any required year combinations.
#
# 3. Population totals
#    Update household, adult and child population estimates.
#
# 4. Input files
#    Add the new year's source datasets.
#
# 5. Calibration totals
#    Update totals files where required.
#
# 6. Required weights
#    Update the final output specification if required by
#    the SHeS team.
#
# Notes
# 
# Year combinations are run automatically by master.R.
#
# Weight-specific scripts select the required files, totals
# and population estimates using the settings defined here.
#
##############################################################

config <- list()

# Year combinations --------------

# specify which year combinations should be run
config$year_runs <- list(
  
  # list years for 4-year weights
  y4 = c(
    20XX,
    20XX,
    20XX,
    20XX
  ),
  
  # list years for alternating 2-year weights( e.g., 2023 and 2025)
  y2alt = c(
    20XX,
    20XX
  ),
  
  # list years for sequential 2-year weights( e.g., 2024 and 2025)
  y2seq = c(
    20XX,
    20XX
  ),
  
  y3 = c(
    20XX,
    20XX,
    20XX
  )
)

# get ref year (usually latest year)
config$ref_year <- max(config$year_runs[[1]])

# Required output weights -------------

# specify which weights are required by the SHeS team
# multi-year weights will be produced for all year combinations but only
# the required variables are collated in the final file
config$required_weights <- list(
  
  # list required 4-year weights
  y4 = c(
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name"
  ),
  
  # list required alternating 2-year weights (e.g., 2023 and 2025)
  y2alt = c(
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name"
  ),
  
  # list required sequential 2-year weights (e.g., 2024 and 2025)
  y2seq = c(
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name"
  ),
  
  y3 = c(
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name",
    "wt_name"
  )
)

if(any(names(config$year_runs) == names(config$required_weights)) == FALSE){
  stop(print(paste0("Names of required weights and years don't align. ",
                    "Investigate and make sure the order is the same in both lists.")
  ))
}

# change names of list items in year_runs
# (e.g., y4alt with values 2023 and 2025 will get renamed to y2325)
names(config$year_runs) <- vapply(
  config$year_runs,
  function(x) paste0("y", paste0(substr(x, 3, 4), collapse = "")),
  character(1)
)

# rename list items to match year_runs
names(config$required_weights) <- names(config$year_runs)

# Population totals --------

# Household populations
config$household_pop <- c(
  "20XX" = XXX,
  "20XX" = XXX,
  "20XX" = XXX,
  "20XX" = XXX
)

# Adult populations
config$adult_pop <- c(
  "20XX" = XXX,
  "20XX" = XXX,
  "20XX" = XXX,
  "20XX" = XXX
)

# Child populations
config$child_pop <- c(
  "20XX" = XXX,
  "20XX" = XXX,
  "20XX" = XXX,
  "20XX" = XXX
)

# Input files -------------

# Path to individual survey year files
config$input_files <- list(
  household = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  adult = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  adult_sc = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  biodesign = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  bioadult = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
  ),
  biophy = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  vera = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  mainchild = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  allchild = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  ),
  verachild = c(
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name",
    y20XX = "dataset name"
  )
)


# Calibration totals --------------

# Paths to multi-year calibration totals
# Some calibration totals are used for multiple weights; to avoid duplication,
# only one file is created in those instances( for example, adult totals 
# are re-used for the bio design weight)
# Calibration totals proportional to ample size are automatically added in R
config$path_totals <- here('calibration_totals')

config$totals_names <- list(
  household = "SHeShhtotals.csv",
  adult = "SHeSadulttotals.csv",
  biomod_adult = "SHeSbiototals.csv",
  child_main = "SHeSChildMainTotals.csv",
  child_all = "SHeSchildtotals.csv"
)

config$totals_files <- lapply(config$totals_names, \(x) file.path(config$path_totals, x))

# File paths -----------------

config$sas_path <- "//path/to/SAS data/"
