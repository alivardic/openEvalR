#' Generate Confusion Matrices for OpenAI Model Outputs
#'
#' Given a dataframe of evaluation results, this function extracts all model output columns
#' and computes a confusion matrix for each using the caret package.
#'
#' @param df the dataframe created by this package's the results function
#' @param groundtruth The name of the column containing the ground_truth labels.
#' @return A list of confusionMatrix objects, one for each model output column.
#' @importFrom dplyr select
#' @importFrom tidyr drop_na
#' @importFrom purrr map
#' @importFrom caret confusionMatrix
#' @importFrom rlang sym
#' @importFrom magrittr %>%
#' @examples
#' cmatrix(df, "item.groundtruth")
#' @export
cmatrix <- function(df, groundtruth) {
  # Find all model output columns
  # While technically this can work with a df just structured like this, the model output columns need to be named:
  # [Something Something]_model_output
  model_output_cols <- grep("_model_output$", names(df), value = TRUE)

  # Create confusion matrix for each model
  confusion_list <- map(model_output_cols, function(model_col) {
    data <- df %>%
      select(!!sym(groundtruth), !!sym(model_col)) %>%
      drop_na()

    # Use levels from model output as the master level set
    # Specifically in our stance Model, we had an issue where we were supposed to have
    # 3 levels in both in input and output, but one of our inputs only ended up having 2
    # levels while the output had all three -- This line helps negate the error we encountered,
    # as we wanted all of the levels shown in the model output.

    # This line specifically is very research specific
    model_levels <- levels(factor(data[[model_col]]))

    # Align both columns to use the same levels
    prediction <- factor(data[[model_col]], levels = model_levels)
    reference  <- factor(data[[groundtruth]], levels = model_levels)

    # Calculate a confusion matrix using caret's confusionMatrix()
    cm <- confusionMatrix(prediction, reference)
    return(cm)
  })

  # Improves Readability
  names(confusion_list) <- model_output_cols
  return(confusion_list)
}
