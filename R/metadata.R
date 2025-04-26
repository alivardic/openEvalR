#' Metadata Extractor for OpenAI Reports
#'
#' This function extracts item.* fields and data_source_idx from an OpenAI evaluation
#' export, allowing users to reconnect model results to their original dataset using
#' the unique identifier extracted using the results() function.
#'
#' @param file_path the OpenAI .jsonl Evaluation file path
#' @return A dataframe consisiting of the data_source_idx and the original dataset uploaded to OpenAI
#' @importFrom jsonlite stream_in
#' @importFrom dplyr select arrange all_of
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' metadata("data/example.jsonl")
#' }
#' @export
metadata <- function(file_path) {
  # Load the JSONL file
  json_data <- stream_in(file(file_path), flatten = TRUE)

  # Grab all item.* columns
  item_cols <- grep("^item\\.", names(json_data), value = TRUE)

  # Add data_source_idx explicitly
  result <- json_data %>%
    select(data_source_idx, all_of(item_cols)) %>%
    arrange(data_source_idx)

  return(result)
}
