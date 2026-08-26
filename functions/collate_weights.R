#' Collate individual weights into a final export file
#'
#' Reads the required individual weight files for a given year combination,
#' selects the relevant weight variable from each file, joins the weights
#' together by `pserial`, and exports a single combined file.
#'
#' Weight files to include are specified in `config$required_weights`.
#' The function assumes:
#'
#' \itemize{
#'   \item Each weight file is stored in the output folder corresponding to
#'         the year combination.
#'   \item Each file contains a `pserial` variable.
#'   \item The required weight variable is in column 5 of the file.
#'   \item Weight files follow the naming convention
#'         `SHeS<weight>.csv`.
#' }
#'
#' The resulting output file is named:
#'
#' \code{Final_Ind_Weights<year combination>.csv}
#'
#' For example:
#'
#' \itemize{
#'   \item `Final_Ind_Weights22232425.csv`
#'   \item `Final_Ind_Weights232425.csv`
#'   \item `Final_Ind_Weights2425.csv`
#' }
#'
#' Weight variables are renamed using the convention:
#'
#' \code{<weight><year combination>wt}
#'
#' For example:
#'
#' \itemize{
#'   \item `int22232425wt`
#'   \item `intsc22232425wt`
#'   \item `bio2425wt`
#' }
#'
#' @param years Numeric vector of years included in the weighting run,
#'   e.g. `c(2022, 2023, 2024, 2025)`.
#'
#' @returns A CSV file written to the relevant output folder. The resulting
#'   file contains one row per `pserial` and one column for each required
#'   weight.
#'
#' @examples
#' \dontrun{
#' collate_weights(
#'   c(2022, 2023, 2024, 2025)
#' )
#' }

collate_weights <- function(years){
  
  # Create folder and file suffixes from year combination
  folder_name <- paste0(years, collapse = "")
  suffix <- paste0(substr(years, 3, 4), collapse = "")
  
  # Define output folder
  output_folder <- file.path(here::here("output"), folder_name)
  
  # Determine which weights should be included
  required_weights <- config$required_weights[[paste0('y', suffix)]]
  
  # Read and prepare individual weight files
  dfs <- purrr::map(
    
    required_weights,
    
    function(weight){
      
      file <- paste0('SHeS', weight, '.csv')
      
      read_csv(file.path(output_folder, file), show_col_types = FALSE) %>%
        select(pserial, 5) %>%
        rename_with(~paste0(weight, suffix, 'wt'), .cols = 2)
      
    }
    
  )
  
  # Join weight files together, ensure they are numeric and sorted by pserial
  final <- reduce(dfs, full_join, by = "pserial") %>%
    mutate(across(everything(), as.numeric)) %>%
    arrange(pserial)
  
  # Export combined file
  write_csv(final,
            file.path(output_folder,
                      paste0("Final_Ind_Weights", suffix, ".csv")))
  
}
