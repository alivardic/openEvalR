#' Calcuate Qwet's AC1 for OpenAI Model Outputs
#'
#' This function computes a Qwet's AC1, an alternate statistic for inter-rater reliability,
#' between a specified ground truth column and each model's output column in a dataframe.
#'
#' @param df the dataframe created by this package's the results function
#' @param groundtruth The name of the column containing the ground_truth labels.
#' @return a list consisting of the Cohen's kappa between each model run and the ground truth
#' @importFrom dplyr select mutate across
#' @importFrom tidyr drop_na
#' @importFrom purrr map
#' @importFrom rlang sym
#' @importFrom irrCAC gwet.ac1.raw
#' @importFrom magrittr %>%
#' @examples
#' qwetAC1(data, "groundtruth")
#' @export
qwetAC1 <- function(df, groundtruth) {
  # Find all model output columns
  # While technically this can work with a df just structured like this, the model output columns need to be named:
  # [Something Something]_model_output
  model_output_cols <- grep("_model_output$", names(df), value = TRUE)

  # Calculates Qwets for each model
  qwet_list <- map(model_output_cols, function(model_col) {
    data <- df %>%
      select(!!sym(groundtruth), !!sym(model_col)) %>%
      drop_na() %>%
      mutate(across(everything(), as.factor))  # Ensure factors

    # qwet.ac1.raw from irrCAC
    qwet <- gwet.ac1.raw(cbind(data[[model_col]], data[[groundtruth]]))$est$coeff.val

    return(qwet)
  })

  # Improves Readability
  names(qwet_list) <- model_output_cols
  return(qwet_list)
}
