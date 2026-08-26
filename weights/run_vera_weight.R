# ==========================================================
# Adult Version A interview weight
# ==========================================================

run_vera_weight <- function(years) {
 
   # Specify inputs ---------------------
  
  pop_total <- config$adult_pop
  input <- config$input_files$vera
  wt_name <- 'vera'
  name <- 'Adult version a'
  totals_input <- config$totals_files$adult
  
  message(paste("Running", tolower(name), "weight:", paste(years, collapse = ", ")))
  
  # Prepare data ---------------------------------------------------
  
  message("Import data")
  
  output_folder <- build_output_folder(years)
  
  files <- get_files_for_years(input, years)
  
  df <- prepare_weight_data(
    files = files,
    years = years,
    weight_var = "pre_verawt1",
    population_vector = pop_total,
    indicator_value = 1
  ) 
  
  n <- nrow(df)
  
  # Load calibration totals -------------------------
  
  totals <- create_calibration_totals(
    totals_file = totals_input,
    data = df,
    population_vector = pop_total,
    ref_year = max(years)
  ) %>%
    
    # Combine Glasgow & Greater Clyde rows
    mutate(group = if_else(
      str_starts(name, "hh2Greater Glasgow & Clyde"),
      "hh2Greater Glasgow & Clyde",
      name
    )) %>%
    group_by(group) %>%
    summarise(
      across(where(is.numeric), \(x) sum(x, na.rm = TRUE)),
      .groups = "drop"
    ) %>%
    rename(name = group) %>%
    
    # rename hh2 to hb_vera
    mutate(name = str_replace(name, "^hh2", "hb_vera"))
  
  # Calibration formula ---------------------------------------------------
  
  model <- build_calibration_formula(
    years = years,
    controls = c(
      "hb_vera",
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
