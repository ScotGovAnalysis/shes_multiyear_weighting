#' Create and return output folder for a year combination
#'
#' Creates an output folder for a given year combination if it does not
#' already exist and returns the full path to the folder.
#'
#' The folder name is constructed by concatenating the years included in
#' the weighting run. For example:
#'
#' * `c(2022, 2023, 2024, 2025)` becomes
#'   `"2022202320242025"`
#' * `c(2024, 2025)` becomes
#'   `"20242025"`
#'
#' Output files for a given year combination can then be written directly
#' to the returned directory.
#'
#' @param years Numeric vector of years included in the weighting run,
#'   e.g. `c(2022, 2023, 2024, 2025)`.
#'
#' @returns A character string containing the full path to the output
#'   folder for the specified year combination.
#'
#' @examples
#' build_output_folder(
#'   c(2022, 2023, 2024, 2025)
#' )
#'
#' build_output_folder(
#'   c(2024, 2025)
#' )

build_output_folder <- function(years){
  
  # Create folder name from year combination
  folder <- paste0(years, collapse = '')
  
  # Construct full output path
  output_path <- here::here("output", folder)
  
  # Create folder if it does not already exist
  dir.create(
    output_path,
    recursive = TRUE,
    showWarnings = FALSE
  )
  
  # Return output path
  output_path
  
}


