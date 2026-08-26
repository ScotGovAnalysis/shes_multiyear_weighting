#' Rescale design weights to the reference year population
#'
#' Rescales the input weight variable so that weights are expressed relative
#' to the population of the reference year.
#'
#' This follows the methodology used in the SAS weighting process:
#'
#' \deqn{
#' \text{preweight1} =
#' \frac{\text{weight}}
#' {\sum(\text{population totals})}
#' \times
#' \text{reference population}
#' }
#'
#' The resulting variable, `preweight1`, is used as the input weight for
#' calibration.
#'
#' @param data A data frame containing the weight variable.
#'
#' @param weight_var Character string containing the name of the weight
#'   variable to be rescaled.
#'
#' @param population_vector Named numeric vector containing the population
#'   totals for all years included in the weighting run.
#'
#' @param reference_population Numeric value representing the population
#'   total of the reference year.
#'
#' @returns The input data frame with an additional variable,
#'   `preweight1`, containing the rescaled weights.
#'
#' @examples
#' \dontrun{
#' household <- rescale_weights(
#'   data = household,
#'   weight_var = "entrywt",
#'   population_vector = config$household_pop[
#'     as.character(years)
#'   ],
#'   reference_population =
#'     config$household_pop[
#'       as.character(max(years))
#'     ]
#' )
#'
#' adult <- rescale_weights(
#'   data = adult,
#'   weight_var = "preweight",
#'   population_vector = config$adult_pop[
#'     as.character(years)
#'   ],
#'   reference_population =
#'     config$adult_pop[
#'       as.character(max(years))
#'     ]
#' )
#' }

rescale_weights <- function(data, weight_var, population_vector,
    reference_population) {
  
  # Calculate total population across all years
  pop_sum <- sum(population_vector)
  
  # Rescale weights to reference year population
  data %>%
    mutate(
      preweight1 =
        .data[[weight_var]] /
        pop_sum *
        reference_population
    )
  
}