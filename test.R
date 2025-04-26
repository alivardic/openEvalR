#' This package was developed as part of the research project titled:
#' "Human and AI Alignment on Stance Detection: A Case Study of the United Healthcare CEO Assassination,"
#' conducted by Dr. Loni Hagen, Alina Hagen, Daniel Tafmizi, Christopher Reddish, Dr. Lingyao Li,
#' Dr. Ashely Fox, and Dr. Nicolau DePaula.
#'
#' The project will be presented as a poster at the FLAIR-38 Conference in May 2025.
#'
#' Due to potential GDPR and data privacy concerns, the original dataset used in the study has not been included.
#' Instead, a synthetic dummy file—generated using ChatGPT-4o—has been provided to replicate the structure
#' of the original data and demonstrate the functionality of the package.
#'
#' Required arguments for example functions:
#' - `file_path = "test.jsonl"`
#' - `groundtruth = "item.stance"`


#' Function Examples:

# Results
df<- results("test.jsonl", "item.stance")

# Metadata
data <- metadata("test.jsonl")

# Kappas
kappa <- kappas(df, "item.stance")

# Confusion Matrix
matrix <- cmatrix(df, "item.stance")

# Qwet AC1
qwets <- qwetAC1(df, "item.stance")
