#' Export weight file
#'
#' Writes a data frame containing survey weights to a CSV file in the
#' specified output folder.
#'
#' This function is used throughout the weighting process to export
#' intermediate or final weight files in a consistent manner.
#'
#' @param data A data frame to be exported.
#'
#' @param output_folder Character string containing the folder path where
#'   the file should be written.
#'
#' @param filename Character string containing the name of the output file,
#'   including the `.csv` extension.
#'
#' @returns No value is returned. The function writes a CSV file to disk.
#'
#' @examples
#' \dontrun{
#' export_weights(
#'   data = hh_wts,
#'   output_folder = here::here(
#'     "output",
#'     "2022202320242025"
#'   ),
#'   filename = "SHeShh.csv"
#' )
#' }

export_weights <- function(data, output_folder, filename){
  
  readr::write_csv(data, file.path(output_folder, filename))
  
}
