###############################################################
# setup.R
#
# Scottish Health Survey (SHeS) Multi-year Weighting RAP
#
# Purpose
# 
# Initialises the weighting environment by:
#
# * Loading all required R packages.
# * Loading the project configuration.
# * Loading all helper functions.
# * Loading all weight-specific scripts.
# * Creating output folders for each year combination.
#
# Usage
# 
# This script should be sourced by master.R before any weighting
# processes are executed.
#
# Inputs
# 
# * config.R
# * functions/
# * weights/
#
# Outputs
# 
# * Creates output directories for all configured year
#   combinations.
# * Loads all required objects into the current R session.
#
# Maintenance
# 
# This script should rarely require modification. Most annual
# updates should be made in:
#
# * config.R
#
# New helper functions should be placed in:
#
# * functions/
#
# New weight types should be placed in:
#
# * weights/
#
#################################################

# Load packages ----------

library(haven)
library(readr)
library(tidyverse)
library(tidyr)
library(stringr)
library(rlang)
library(survey)
library(srvyr)
library(janitor)
library(ReGenesees)
library(here)

# Load configuration ---------------

source(here::here("config.R"))


# Load helper functions -------------

walk(
  
  list.files(
    here::here("functions"),
    pattern = "\\.R$",
    full.names = TRUE
  ),
  
  source
  
)

# Load weight scripts -------------

walk(
  list.files(
    here("weights"),
    pattern = "\\.R$",
    full.names = TRUE
  ),
  source
)


# Create output folders ----------

walk(
  config$year_runs,
  function(years) {
    
    folder_name <- paste0(
      paste0(years, collapse = '')
    )
    
    message(paste("Creating output folder:", folder_name))
    
    dir.create(
      file.path(
        here::here(),
        "output",
        folder_name
      ),
      recursive = TRUE,
      showWarnings = FALSE
    )
    
  }
)

message("Setup complete")
