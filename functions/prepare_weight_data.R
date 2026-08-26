#' Load and prepare weighting data for a specified year combination
#'
#' Imports survey data for each year in a weighting run, applies standard
#' preprocessing steps, creates year indicator variables and rescales the
#' input weights to the reference year population.
#'
#' The function performs the following operations:
#' \itemize{
#'   \item Imports each dataset using `load_input_file()`.
#'   \item Converts all variable names to lower case.
#'   \item Converts selected identifier variables to numeric where present.
#'   \item Creates year indicator variables using
#'         `create_year_indicators()`.
#'   \item Rescales the input weights using `rescale_weights()`.
#'   \item Combines all years into a single data frame.
#' }
#'
#' @param files A named character vector of input files to process. Names
#'   should follow the format `"yYYYY"`, e.g. `"y2025"`.
#'
#' @param years Numeric vector of years included in the weighting run,
#'   e.g. `c(2022, 2023, 2024, 2025)`.
#'
#' @param weight_var Character string containing the name of the input
#'   weight variable to be rescaled.
#'
#' @param population_vector Named numeric vector containing the relevant
#'   population totals for the weighting run.
#'
#' @param indicator_value Either:
#'   \itemize{
#'     \item A character string containing the name of the variable used to
#'           populate the year indicator.
#'     \item A numeric constant (typically `1`) used to populate the year
#'           indicator.
#'   }
#'
#' @returns A single data frame containing all years specified in `years`,
#'   with:
#'   \itemize{
#'     \item Standardised variable names.
#'     \item Year indicator variables.
#'     \item A two-digit year variable.
#'     \item A rescaled weight variable (`preweight1`).
#'   }
#'
#' @examples
#' \dontrun{
#' household <- prepare_weight_data(
#'   files = config$input_files$household,
#'   years = c(2022, 2023, 2024, 2025),
#'   weight_var = "entrywt",
#'   population_vector = config$household_pop,
#'   indicator_value = "noftot"
#' )
#'
#' adult <- prepare_weight_data(
#'   files = config$input_files$adult,
#'   years = c(2022, 2023, 2024, 2025),
#'   weight_var = "preweight",
#'   population_vector = config$adult_pop,
#'   indicator_value = 1
#' )
#' }

prepare_weight_data <- function(files, years, weight_var, population_vector,
  indicator_value){
  
  datasets <-
    purrr::imap(files,
                function(file, nm){
                  
                  # Extract year from file name
                  year <- stringr::str_extract(nm, "\\d{4}")
        
        load_input_file(file) %>%
          
          # Standardise variable names
          rename_with(tolower) %>%
          
          # Rename weight variable for 2026 onwards; all preweights will be named preweight
        {
          if (as.numeric(year) >= 2026) {
            rename(., preweight = all_of(weight_var))
          } else {
            .
          }
        } %>%
          
          # Convert selected identifiers to numeric where present
          mutate(across(any_of(c("pers_num", "la_code", "hbcode")), as.numeric)) %>%
          
          # Create year indicator variables
          create_year_indicators(
            year = as.numeric(year),
            years = years,
            value = indicator_value
          ) %>%
          
          # Rescale weights to reference year population
          rescale_weights(
            weight_var = weight_var,
            population_vector = population_vector[as.character(years)],
            reference_population = population_vector[as.character(
                  max(years))])
      }
    )
  
  # Combine all years into a single dataset
  bind_rows(datasets)
  
}
