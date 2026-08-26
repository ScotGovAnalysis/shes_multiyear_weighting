#' Recode child main sample health board categories
#'
#' Recodes health board categories used in the main child weight calibration
#' into the grouped categories required by the calibration totals.
#'
#' The recoding combines certain health boards where cell sizes are too small
#' for calibration or where categories have been collapsed in the population
#' totals. For example:
#'
#' \itemize{
#'   \item Borders and Dumfries & Galloway are combined.
#'   \item Highland, Orkney, Shetland and Western Isles are grouped as
#'         "Other".
#' }
#'
#' This corresponds to the grouped health board variable used in the
#' child main sample weighting calibration.
#'
#' @param df A data frame containing the health board variable to recode.
#'
#' @param var Unquoted variable name containing the health board codes.
#'   Defaults to `hlthbrdva`.
#'
#' @returns The input data frame with the specified health board variable
#' recoded to character categories suitable for calibration.
#'
#' @examples
#' \dontrun{
#' child_data <- recode_childmainhb(
#'   child_data
#' )
#'
#' child_data <- recode_childmainhb(
#'   child_data,
#'   hbcode
#' )
#' }

recode_childmainhb <- function(df, var = hlthbrdva) {
  
  lookup <- c(
    "1"  = "Ayrshire & Arran",
    "2"  = "Dumfries & Galloway / Borders",
    "3"  = "Dumfries & Galloway / Borders",
    "4"  = "Fife",
    "5"  = "Forth Valley",
    "6"  = "Grampian",
    "7"  = "Greater Glasgow & Clyde",
    "8"  = "Other",
    "9"  = "Lanarkshire",
    "10" = "Lothian",
    "11" = "Other",
    "12" = "Other",
    "13" = "Tayside",
    "14" = "Other",
    
    "90" = "Other",
    "93" = "Dumfries & Galloway / Borders",
    "94" = "Fife & Forth Valley"
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