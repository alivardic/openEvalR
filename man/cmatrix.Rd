% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cmatrix.R
\name{cmatrix}
\alias{cmatrix}
\title{Generate Confusion Matrices for OpenAI Model Outputs}
\usage{
cmatrix(df, groundtruth)
}
\arguments{
\item{df}{the dataframe created by this package's the results function}

\item{groundtruth}{The name of the column containing the ground_truth labels.}
}
\value{
A list of confusionMatrix objects, one for each model output column.
}
\description{
Given a dataframe of evaluation results, this function extracts all model output columns
and computes a confusion matrix for each using the caret package.
}
\examples{
cmatrix(df, "item.groundtruth")
}
