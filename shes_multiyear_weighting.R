############################################################
# master.R
#
# Scottish Health Survey (SHeS) Multi-year Weighting RAP
#
# Purpose
# 
# Controls and executes the full weighting process.
#
# This script:
#
# * Sources the setup script.
# * Runs all weighting methodologies for each configured
#   year combination.
# * Produces final collated weight files.
#
# Workflow
#
# For each year combination defined in:
#
#   config$year_runs
#
# the following weights are produced:
#
# * Household weight
# * Adult interview weight
# * Adult self-completion weight
# * Biomod design weight
# * Biomod adult weight
# * Biomod physical weight
# * Version A weight
# * Main child weight
# * All child weight
# * Child Version A weight
#
# After all weights have been created, the required
# weights are collated into:
#
#   Final_Ind_Weights<year combination>.csv
#
# Example outputs:
#
# * Final_Ind_Weights22232425.csv
# * Final_Ind_Weights2325.csv
# * Final_Ind_Weights2425.csv
#
# Inputs

# * config.R
# * functions/
# * weights/
#
# Outputs

# Weight files and final collated outputs are written to:
#
#   output/<year combination>/
#
# Usage
# Run this script to execute the complete weighting process.
#
###############################################################


# Setup ----

source(here::here("setup.R"))


# Run weighting process ----


walk(
  
  config$year_runs,
  
  function(years){
    
    message(paste("Processing year combination:", paste(years, collapse = ", ")))
    
    run_household_weight(years)
    
    run_adult_weight(years)
    
    run_adult_sc_weight(years)
    
    run_biodesign_weight(years)
    
    run_bioadult_weight(years)
    
    run_biophy_weight(years)
    
    run_vera_weight(years)
    
    run_mainchild_weight(years)
    
    run_allchild_weight(years)
    
    run_childvera_weight(years)
    
    collate_weights(years)
    
  }
  
)

# Finished ----


message("FINISHED - All weights have been produced")
