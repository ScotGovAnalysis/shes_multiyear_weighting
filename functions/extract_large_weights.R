#' Extract records with large weights for quality assurance
#'
#' Identifies records with weights above a specified threshold. These records
#' can be reviewed as part of the weighting quality assurance process to
#' determine whether large weights are occurring in expected underrepresented
#' population groups.
#'
#' By default, records with weights greater than 1000 are returned.
#'
#' @param data A data frame containing the weight variable.
#'
#' @param weight Character string containing the name of the weight variable
#'   to assess.
#'
#' @param threshold Numeric threshold above which a weight is considered
#'   large. Defaults to `1000`.
#'
#' @returns A data frame containing only records where the specified weight
#'   exceeds the threshold.
#'
#' @examples
#' \dontrun{
#' large_wts <- extract_large_weights(
#'   data = result$data,
#'   weight = "SHeS_int_wt"
#' )
#'
#' large_hh_wts <- extract_large_weights(
#'   data = result$data,
#'   weight = "SHeS_hh_wt",
#'   threshold = 500
#' )
#' }

extract_large_weights <- function(data, weight, threshold = 1000){
  
  data %>% filter(.data[[weight]] > threshold)

  }
