#' Subset input files for a given year combination
#'
#' Returns the subset of input files corresponding to the years included in
#' a weighting run.
#'
#' The function assumes that the names of the input files are in the format
#' `"yYYYY"`, for example:
#'
#' \itemize{
#'   \item `y2022`
#'   \item `y2023`
#'   \item `y2024`
#'   \item `y2025`
#' }
#'
#' and that these names correspond to the years supplied in the `years`
#' argument.
#'
#' This function is used to select only the files required for a particular
#' year combination prior to data preparation and calibration.
#'
#' @param files A named character vector of input file paths. Names should
#'   follow the format `"yYYYY"`.
#'
#' @param years Numeric vector of years to include in the weighting run,
#'   e.g. `c(2022, 2023, 2024, 2025)`.
#'
#' @returns A named character vector containing only the files associated
#'   with the requested years.
#'
#' @examples
#' files <- c(
#'   y2022 = "shes22_adults_precalib.sas7bdat",
#'   y2023 = "shes23_adults_precalib.sas7bdat",
#'   y2024 = "shes24_adults_precalib.sas7bdat",
#'   y2025 = "shes25_adults_precalib.sas7bdat"
#' )
#'
#' get_files_for_years(
#'   files,
#'   c(2024, 2025)
#' )
#'
#' # Returns:
#' # y2024 y2025
#'

get_files_for_years <- function(files, years){
  files[paste0("y", years)]
}
