#' Build a calibration formula dynamically
#'
#' Creates an R formula for use in the calibration step by combining
#' year indicator variables and calibration control variables. This allows
#' the same weighting code to be used for different year combinations
#' without hard-coding the formula.
#'
#' For example, if:
#'
#' * `years = c(2022, 2023, 2024, 2025)`
#' * `controls = c("hh2", "agesex")`
#'
#' the resulting formula will be:
#'
#' `~ y22 + y23 + y24 + y25 + hh2 + agesex - 1`
#'
#' @param years Numeric vector of years included in the weighting run,
#'   e.g. `c(2022, 2023, 2024, 2025)`.
#'
#' @param controls Character vector containing the names of the calibration
#'   control variables to include in the model.
#'
#' @returns An object of class `"formula"` suitable for use as the
#'   calibration model in `calibrate_weights()`.
#'
#' @examples
#' build_calibration_formula(
#'   years = c(2022, 2023, 2024, 2025),
#'   controls = c("hh2", "agesex")
#' )
#'
#' build_calibration_formula(
#'   years = c(2024, 2025),
#'   controls = c(
#'     paste0("total", 1:14),
#'     paste0("SIMDQ", 1:5, "TOT")
#'   )
#' )

build_calibration_formula <- function(years, controls){
  
  # Create year indicator variable names
  year_terms <- paste0("y", substr(years,3,4))
  
  # Build calibration formula
  as.formula(
    paste("~",
          paste(c(year_terms,controls), collapse = " + "),
          "- 1"))
  
}
