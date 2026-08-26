#' Run calibration and create scaled weights
#'
#' Performs the full calibration step for a weighting dataset using the
#' specified calibration totals and model. The function applies calibration
#' using `calibrate_weights()`, renames the resulting calibrated weight, and
#' creates a scaled version of the weight that sums to the number of
#' observations.
#'
#' The scaled weight is calculated as:
#'
#' \deqn{
#' \text{scaled weight} =
#' \text{calibrated weight}
#' \times
#' \frac{\text{number of observations}}
#' {\text{population total}}
#' }
#'
#' This produces:
#'
#' \itemize{
#'   \item An unscaled calibrated weight that sums to the population total.
#'   \item A scaled calibrated weight that sums to the sample size.
#' }
#'
#' @param data A data frame containing the records to be calibrated.
#'
#' @param totals A data frame containing the calibration totals used by
#'   `calibrate_weights()`.
#'
#' @param ids A survey design formula specifying the survey unit identifier,
#'   e.g. `~Serial_N` or `~pserial`.
#'
#' @param model A calibration model formula specifying the variables to be
#'   used in calibration.
#'
#' @param bounds Numeric vector of length two specifying the lower and upper
#'   calibration bounds.
#'
#' @param weight_name Character string containing the desired name of the
#'   calibrated weight variable.
#'
#' @param scaled_weight_name Character string containing the desired name of
#'   the scaled calibrated weight variable.
#'
#' @param population_total Numeric population total corresponding to the
#'   reference year. Used when creating the scaled weight.
#'
#' @returns A list containing:
#' \itemize{
#'   \item `data` - The calibrated dataset including the calibrated and
#'   scaled weights.
#'   \item `poptemp` - The population template created during calibration.
#'   \item `poptot` - The calibration totals matrix used for calibration.
#' }
#'
#' @examples
#' \dontrun{
#' result <- run_calibration(
#'   data = household,
#'   totals = totals,
#'   ids = ~Serial_N,
#'   model = model,
#'   bounds = c(-2.5, 2.5),
#'   weight_name = "SHeS_hh_wt",
#'   scaled_weight_name = "SHeS_hh_wt_sc",
#'   population_total = 5385764
#' )
#' }

run_calibration <- function(data, totals, ids, model, bounds,
                            weight_name, scaled_weight_name,
                            population_total) {
  
  # Number of observations
  n <- nrow(data)
  
  # Perform calibration
  result <- calibrate_weights(
    
    rf.data = data,
    
    df.population = totals,
    
    ids = ids,
    
    strata = NULL,
    
    preweight = "preweight1",
    
    model = model,
    
    calfun = "raking",
    
    bounds = bounds,
    
    sigma2 = NULL
    
  )
  
  # Rename calibrated weight
  names(result$data)[names(result$data) == "preweight1.cal"] <- weight_name
  
  # Create scaled weight
  result$data[[scaled_weight_name]] <-
    
    result$data[[weight_name]] *
    
    (n / population_total)
  
  # Return calibration outputs
  return(result)
  
}
