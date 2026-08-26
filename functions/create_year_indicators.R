#' Create year indicator variables for calibration
#'
#' Creates a year indicator variable for each year included in a weighting
#' run. All year indicators are initialised to zero and the indicator
#' corresponding to the current dataset year is populated with either a
#' constant value or the values from an existing variable.
#'
#' For example, if `years = c(2022, 2023, 2024, 2025)` and
#' `year = 2023`, the function creates:
#'
#' * `y22`
#' * `y23`
#' * `y24`
#' * `y25`
#'
#' with only `y23` populated.
#'
#' The function also creates a two-digit numeric `year` variable which is
#' used later in the weighting process.
#'
#' @param data A data frame containing survey records.
#'
#' @param year Numeric year corresponding to the dataset being processed,
#'   e.g. `2023`.
#'
#' @param years Numeric vector of all years included in the weighting run,
#'   e.g. `c(2022, 2023, 2024, 2025)`.
#'
#' @param value Either:
#'   \itemize{
#'     \item A character string specifying a variable name whose values
#'     should populate the year indicator (e.g. `"noftot"`).
#'     \item A numeric constant to assign to the indicator variable
#'     (e.g. `1`).
#'   }
#'
#' @returns The input data frame with:
#' \itemize{
#'   \item A year indicator variable for each year in `years`
#'         (e.g. `y22`, `y23`, `y24`, `y25`).
#'   \item A two-digit numeric `year` variable.
#' }
#'
#' @examples
#' df <- create_year_indicators(
#'   data = df,
#'   year = 2023,
#'   years = c(2022, 2023, 2024, 2025),
#'   value = 1
#' )
#'
#' df <- create_year_indicators(
#'   data = df,
#'   year = 2023,
#'   years = c(2022, 2023, 2024, 2025),
#'   value = "noftot"
#' )

create_year_indicators <- function(data, year, years, value){
  
  # Create a year indicator variable for every year in the run
  for(y in years){
    data[[paste0("y", substr(y, 3, 4))]] <- 0
  }
  
  # Identify the indicator corresponding to the current dataset year
  current_year <- paste0("y", substr(year, 3, 4))
  
  # Populate the current year indicator
  if(is.character(value)){
    data[[current_year]] <- data[[value]]
  } else {
    data[[current_year]] <- value
  }
  
  # Create a two-digit year variable
  data$year <- as.numeric(substr(year, 3, 4))
  
  data
  
}
