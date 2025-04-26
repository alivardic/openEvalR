#' Extract Model Results from OpenAI Evaluation reports
#'
#' This function will read a JSONL file containing model-generated outputs,
#' extract relevant fields, and reshape the data so that outputs from multiple
#' models for each unique item are displayed side by side in a standard dataframe.
#'
#' @param file_path the OpenAI .jsonl Evaluation file path
#' @param groundtruth the full name of the ground-truth column
#' @return A dataframe consisiting of the data_source_idx, the ground-truth column,
#' and any model-result pairing for each model in the test.
#' @importFrom jsonlite stream_in
#' @importFrom dplyr mutate select group_by arrange row_number ungroup all_of
#' @importFrom tidyr pivot_wider
#' @importFrom stringr str_extract
#' @importFrom purrr map_chr
#' @importFrom rlang sym
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' results("data/example.jsonl", "groundtruth")
#' }
#' @export
results <- function(file_path, groundtruth) {
  # Load JSONL file
  json_data <- stream_in(file(file_path), flatten = TRUE)

  # Extract Model Results from the nested .jsonl files
  json <- json_data %>%
    mutate(model_output = map_chr(sample.outputs, ~ .x[[2]])) %>%
    select(data_source_idx, !!sym(groundtruth), sample.sampled_model_name, model_output)

  # Assign model index to each sample
  json_prepped <- json %>%
    group_by(data_source_idx) %>%
    arrange(sample.sampled_model_name, .by_group = TRUE) %>%
    mutate(model_index = row_number()) %>%
    ungroup()

  # Pivot to wide format
  # data_source_idx included for ease of metadata linking
  json_wide <- json_prepped %>%
    pivot_wider(
      id_cols = c(data_source_idx, !!sym(groundtruth)),
      names_from = model_index,
      values_from = c(sample.sampled_model_name, model_output),
      names_glue = "model_{model_index}_{.value}"
    )

  # Reorder model columns: name then output per model
  all_cols <- names(json_wide)
  meta_cols <- all_cols[1:2]
  model_cols <- setdiff(all_cols, meta_cols)

  # Extract numeric order while preserving order
  model_indices <- unique(str_extract(model_cols, "(?<=model_)\\d+"))

  # Interleave model name + output per index
  reordered_model_cols <- unlist(lapply(model_indices, function(i) {
    grep(paste0("^model_", i, "_(sample\\.sampled_model_name|model_output)$"), model_cols, value = TRUE)
  }))

  # Recombine and return
  json_wide <- json_wide %>% select(all_of(c(meta_cols, reordered_model_cols)))
  return(json_wide)
}
