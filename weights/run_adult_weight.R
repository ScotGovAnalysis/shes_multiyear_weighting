# ==========================================================
# Adult interview weight
# ==========================================================

run_adult_weight <- function(years) {
  
  # Specify inputs ---------------------
  
  pop_total <- config$adult_pop
  input <- config$input_files$adult
  wt_name <- 'int'
  name <- 'Adult'
  totals_input <- config$totals_files$adult
  
  message(paste("Running", tolower(name), "weight:", paste(years, collapse = ", ")))
  
  # Prepare data ---------------------------------------------------
  
  message("Import data")
  
  output_folder <- build_output_folder(years)
  
  files <- get_files_for_years(input, years)
  
  df <- prepare_weight_data(
    files = files,
    years = years,
    weight_var = "preweight",
    population_vector = pop_total,
    indicator_value = 1
  ) %>%
    
    recode_hh()
  
  n <- nrow(df)
  
  # Load calibration totals -------------------------
  
  totals <- create_calibration_totals(
    totals_file = totals_input,
    data = df,
    population_vector = pop_total,
    ref_year = max(years)
  )
  
  # Calibration formula ---------------------------------------------------
  
  model <- build_calibration_formula(
    years = years,
    controls = c(
      "hh2",
      "agesex"
    )
  )
  
  # Calibration ---------------------------------------------------
  
  message("Calibration")
  
  result <- run_calibration(
    data = df,
    totals = totals,
    ids = ~pserial,
    model = model,
    bounds = c(-Inf, Inf),
    weight_name = paste0("SHeS_", wt_name, "_wt"),
    scaled_weight_name = paste0("SHeS_", wt_name, "_wt_sc"),
    population_total = pop_total[[as.character(max(years))]]
  )
  
  # QA ---------------------------------------------------
  
  message('Checking')
  
  check_weights(
    data = result$data,
    expected_n = n,
    pop_n = pop_total[[as.character(config$ref_year)]],
    weight = paste0("SHeS_", wt_name, "_wt")
  )
  
  # Large weights
  large_wts <- extract_large_weights(
    result$data,
    paste0("SHeS_", wt_name, "_wt")
  )
  
  # Export ---------------------------------------------------
  
  message("Export")
  
  export_weights(
    data = result$data %>%
      select(
        pserial,
        preweight1,
        year,
        starts_with(paste0("SHeS_", wt_name))
      ),
    output_folder = output_folder,
    filename = paste0("SHeS", wt_name, ".csv")
  )
  
  export_weights(
    data = large_wts %>%
      select(
        pserial,
        preweight1,
        year,
        starts_with(paste0("SHeS_", wt_name))
      ),
    output_folder = output_folder,
    filename = paste0("large_", wt_name, "_wts.csv")
  )
  
  message(paste(name, " weight finished:", 
                paste(years, collapse = ", ")))
  
  invisible(result)
  
}