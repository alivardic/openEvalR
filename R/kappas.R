#' Calcuate Cohens Kappa for OpenAI Model Outputs
#'
#' This function calculates Cohen’s Kappa between a specified ground truth column
#' and each model's output column in a dataframe. It helps evaluate how closely
#' each model agrees with the human-labeled data, providing a standardized metric
#' of inter-annotator reliability.
#'
#' @param df the dataframe created by this package's the results function
#' @param groundtruth The name of the column containing the ground_truth labels.
#' @return a dataframe consisting of the Cohen's kappa between each model run and the ground truth
#' @importFrom dplyr select mutate_all
#' @importFrom tidyr drop_na
#' @importFrom purrr map_dfr
#' @importFrom rlang sym
#' @importFrom irr kappa2
#' @importFrom magrittr %>%
#' @examples
#' kappas(data, "groundtruth")
#' @export
kappas <- function(df, groundtruth) {
  # Get all model output columns (assumes naming convention used by `results()`)
  # While technically this can work with a df just structured like this, the model output columns need to be named:
  # [Something Something]_model_output
  model_output_cols <- grep("_model_output$", names(df), value = TRUE)

  # Calculate Cohen’s Kappa for each model
  results <- map_dfr(model_output_cols, function(model_col) {
    data <- df %>%
      select(!!sym(groundtruth), !!sym(model_col)) %>%
      drop_na() # Preferably there shouldn't be any but just in case

    # Ensure both columns are factors for proper kappa handling
    data <- data %>% mutate_all(as.factor)

    # Calculate kappa using irr's kappa2()
    kappa_score <- kappa2(data)$value

    data.frame(
      model_output = model_col,
      groundtruth = groundtruth,
      kappa = kappa_score
    )
  })

  return(results)
}
