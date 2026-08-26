#' Load an input file
#'
#' Imports a survey input file and returns it as a data frame. The function
#' supports SAS datasets (`.sas7bdat`), CSV files (`.csv`) and R objects
#' (`.RDS`).
#'
#' The full file path is constructed using `config$sas_path` and the file
#' name supplied in `file`.
#'
#' @param file Character string containing the file name to be imported.
#'   Supported file types are:
#'   \itemize{
#'     \item `.sas7bdat`
#'     \item `.csv`
#'     \item `.RDS`
#'   }
#'
#' @returns A data frame containing the imported survey data.
#'
#' @examples
#' \dontrun{
#' hh_data <- load_input_file(
#'   "shes25_hhwt_precalib.sas7bdat"
#' )
#'
#' adult_data <- load_input_file(
#'   "shes25_adults_precalib.sas7bdat"
#' )
#'
#' calibration_totals <- load_input_file(
#'   "totals.csv"
#' )
#' }

load_input_file <- function(file){
  
  # Construct full file path
  path <- paste0(config$sas_path, file)
  
  # Import SAS dataset
  if(grepl("\\.sas7bdat$", file)){
    return(haven::read_sas(path))
  }
  
  # Import CSV file
  if(grepl("\\.csv$", file)){
    return(readr::read_csv(path, show_col_types = FALSE))
  }
  
  # Import RDS file
  if(grepl("\\.RDS$", file, ignore.case = TRUE)){
    return(readRDS(path))
  }
  
  # Unsupported file type
  stop("Unknown file type")
  
}
