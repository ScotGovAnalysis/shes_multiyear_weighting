#' Recode household calibration categories
#'
#' Recodes household calibration categories used in the adult and adult
#' self-completion weighting processes. The function converts numeric
#' household category codes into the character labels used in the household
#' calibration totals file.
#'
#' Categories represent Scottish health boards, with additional categories
#' used for Greater Glasgow & Clyde age-sex groups.
#'
#' @param df A data frame containing the household calibration variable.
#'
#' @param var Unquoted variable name containing the household calibration
#'   categories. Defaults to `hh2`.
#'
#' @returns The input data frame with the specified variable recoded to
#'   character categories suitable for calibration.
#'
#' @examples
#' \dontrun{
#' adult_data <- recode_hh(adult_data)
#'
#' adult_data <- recode_hh(
#'   adult_data,
#'   hh3
#' )
#' }

recode_hh <- function(df, var = hh2) {
  
  lookup <- c(
    "1"  = "Ayrshire & Arran",
    "2"  = "Borders",
    "3"  = "Dumfries & Galloway",
    "4"  = "Fife",
    "5"  = "Forth Valley",
    "6"  = "Grampian",
    "7"  = "Greater Glasgow & Clyde",
    "8"  = "Highland",
    "9"  = "Lanarkshire",
    "10" = "Lothian",
    "11" = "Orkney",
    "12" = "Shetland",
    "13" = "Tayside",
    "14" = "Western Isles",
    
    "20" = "Greater Glasgow & ClydeMale45",
    "21" = "Greater Glasgow & ClydeMale6",
    "22" = "Greater Glasgow & ClydeMale7",
    "23" = "Greater Glasgow & ClydeMale8",
    "24" = "Greater Glasgow & ClydeMale910",
    "25" = "Greater Glasgow & ClydeFemale45",
    "26" = "Greater Glasgow & ClydeFemale6",
    "27" = "Greater Glasgow & ClydeFemale7",
    "28" = "Greater Glasgow & ClydeFemale8",
    "29" = "Greater Glasgow & ClydeFemale910"
  )
  
  lookup_2021 <- c(
    "15" = "1",
    "16" = "2",
    "17" = "3",
    "29" = "4",
    "19" = "5",
    "20" = "6",
    "31" = "7",
    "22" = "8",
    "32" = "9",
    "24" = "10",
    "25" = "11",
    "26" = "12",
    "30" = "13",
    "28" = "14",
    "40" = "20",
    "41" = "21",
    "42" = "22",
    "43" = "23",
    "44" = "24",
    "45" = "25",
    "46" = "26",
    "47" = "27",
    "48" = "28",
    "49" = "29"
  )
  
  # recode hh2 if data is from 2021 (correct coding)
  if ("y21" %in% names(df)) {
    df <- df %>%
      mutate(
        {{ var }} := replace(
          as.character({{ var }}),
          y21 == 1,
          recode(
            as.character({{ var }})[y21 == 1],
            !!!lookup_2021,
            .default = as.character({{ var }})[y21 == 1]
          )
        )
      )
  }
  
  # recode all hh2
  df <- df %>%
    mutate(
      {{ var }} := recode(
        as.character({{ var }}),
        !!!lookup,
        .default = as.character({{ var }})
      )
    )
  
  
}
