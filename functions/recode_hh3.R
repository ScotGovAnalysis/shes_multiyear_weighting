#' Recode health board grouping for biomod adult weighting
#'
#' Recodes the health board grouping variable used in the biomod adult
#' weighting calibration. Several health boards are combined into larger
#' categories to improve calibration stability and ensure sufficient sample
#' sizes within calibration groups.
#'
#' The recoding follows the methodology used in the SAS weighting process:
#'
#' \itemize{
#'   \item Borders and Dumfries & Galloway are combined.
#'   \item Orkney, Shetland and Western Isles are grouped as "Other".
#'   \item Existing values of 30 and 33 are retained.
#' }
#'
#' By default, the function recodes the variable `hh3`.
#'
#' @param df A data frame containing the health board grouping variable.
#'
#' @param var The variable to be recoded. Defaults to `hh3`.
#'
#' @returns The input data frame with the specified variable recoded to the
#'   calibration categories required for biomod adult weighting.
#'
#' @examples
#' \dontrun{
#' biomod_data <- biomod_data %>%
#'   recode_hh3()
#'
#' biomod_data <- biomod_data %>%
#'   recode_hh3(hb_group)
#' }
#'
#' @details
#' The resulting categories are:
#' \itemize{
#'   \item Ayrshire & Arran
#'   \item Dumfries & Galloway / Borders
#'   \item Fife
#'   \item Forth Valley
#'   \item Grampian
#'   \item Greater Glasgow & Clyde
#'   \item Highland
#'   \item Lanarkshire
#'   \item Lothian
#'   \item Tayside
#'   \item Other
#' }

recode_hh3 <- function(df, var = hh3) {
  
  lookup <- c(
    
    "1"  = "Ayrshire & Arran",
    "2"  = "Dumfries & Galloway / Borders",
    "3"  = "Dumfries & Galloway / Borders",
    "4"  = "Fife",
    "5"  = "Forth Valley",
    "6"  = "Grampian",
    "7"  = "Greater Glasgow & Clyde",
    "8"  = "Highland",
    "9"  = "Lanarkshire",
    "10" = "Lothian",
    "11" = "Other",
    "12" = "Other",
    "13" = "Tayside",
    "14" = "Other",
    
    "30" = "Other",
    "33" = "Dumfries & Galloway / Borders"
    
  )
  
  df %>%
    mutate(
      {{ var }} :=
        dplyr::recode(
          as.character({{ var }}),
          !!!lookup,
          .default = as.character({{ var }})
        )
    )
  
}