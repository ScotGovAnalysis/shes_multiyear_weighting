#' Validate calibrated weights
#'
#' Performs a series of validation checks on calibrated and scaled weights.
#' For each weight, the function checks:
#'
#' \itemize{
#'   \item The number of records matches the expected number of observations.
#'   \item The sum of the unscaled weight equals the target population total.
#'   \item The sum of the scaled weight equals the number of observations.
#' }
#'
#' The function assumes that for every calibrated weight there is a
#' corresponding scaled weight with the suffix `"_sc"`.
#'
#' For example, if `weight = "SHeS_int_wt"`, the function will validate:
#'
#' * `SHeS_int_wt`
#' * `SHeS_int_wt_sc`
#'
#' Validation will stop the weighting process if any check fails.
#'
#' @param data A data frame containing the calibrated weights.
#'
#' @param expected_n Numeric. Expected number of observations in the
#'   calibrated dataset.
#'
#' @param pop_n Numeric. Target population total used in calibration.
#'
#' @param weight Character string containing the name of the calibrated
#'   weight variable to check (without the `"_sc"` suffix).
#'
#' @returns No value is returned. The function throws an error if any check
#'   fails and otherwise prints confirmation messages.
#'
#' @examples
#' \dontrun{
#' check_weights(
#'   data = result$data,
#'   expected_n = nrow(adult),
#'   pop_n = config$adult_pop[
#'     as.character(max(years))
#'   ],
#'   weight = "SHeS_int_wt"
#' )
#' }
#' 
#' 

check_weights <- function(data, expected_n, pop_n, weight){
  
  # Create scaled weight name
  wt_sc <- paste0(weight, '_sc')
  
  # Store both weights for checking
  wts <- c(weight, wt_sc)
  
  # Loop through each weight
  for(i in wts){
    
    # Calculate weight distribution statistics
    check <- distribution_check(data, !!rlang::sym(i))
    
    # Check record count -----
    
    if(abs(check$count - expected_n) > 1e-8){
      stop(paste(i,"record count failed")
      )
      
    } else {
      print(paste("Number of", i, "observations correct, continuing..."))
    }
    
    # Check weight sum ----
    
    if(!all.equal(check$sum, ifelse(grepl("_sc$", i), expected_n, pop_n))){
      stop(paste(i,"record sum failed")
      )
      
    } else {
      print(paste0("Sum of ", i, " weights matches ",
                   ifelse(grepl("_sc$", i), 'number of observations', 
                          "population totals"), ", continuing..."))
    }
    
  }
  
  
}
