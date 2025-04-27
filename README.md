
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openEvalR

<!-- badges: start -->
<!-- badges: end -->

`openEvalR` is an R package built to streamline the parsing,
transformation, and evaluation of OpenAI-generated `.jsonl` files,
specifically those exported from structured model evaluations in the
OpenAI developer platform.

------------------------------------------------------------------------

## 📚 Research Context

This tool was created in connection with the research project:

***Human and AI Alignment on Stance Detection: A Case Study of the
United Healthcare CEO Assassination***  
Presented at **FLAIR-38 Conference**, May 2025  
**Authors:** Dr. Loni Hagen, Alina Hagen, Daniel Tafmizi, Christopher
Reddish, Dr. Lingyao Li, Dr. Ashely Fox, Dr. Nicolau DePaula

------------------------------------------------------------------------

## 📝 Development Notes

> **Note 1:**  
> Although this package was used during the above study, it was
> developed independently by *Alina Hagen* as part of a final project
> for LIS 4370. None of the aforementioned research study authors
> contributed to this package, its design, or development.  
> While contributing to the study as one of its analysts, I found myself
> repeatedly needing tools to parse, transform, and evaluate large
> `.jsonl` model output files.  
> `openEvalR` stemmed from those needs – and the opportunity to
> formalize my workflow for class.  
> Its inclusion in the study workflow was a natural extension of its
> utility.

> **Note 2:**  
> Because this package was designed specifically to support the
> structure of the stance detection research study, its use cases are
> fairly limited.  
> The functions in `openEvalR` are tailored to match the **exact**
> format and evaluation outputs used in that study – **not generalized
> OpenAI outputs or other `.jsonl` schemas**; although an effort was
> made to improve generalizability, ultimently this package works best
> with the stance detection study’s model results. While potentially
> useful to others working on similar stance detection tasks, it is
> ultimately a purpose-built tool for a single research pipeline.

------------------------------------------------------------------------

## 📦 Installation

You can install the development version of `openEvalR` like so:

``` r
# Install the development version from GitHub
install.packages("devtools") # Only if you don't already have it
devtools::install_github("alinahagen/openEvalR")
```

## Example

Below is an example of how functions from this package may be used and
how parameters should be formatted when calling each function.

``` r
library(openEvalR)

#' Example arguments for example functions:
#' - `file_path = "test.jsonl"`
#' - `groundtruth = "item.stance"`

# Results (Creates a Dataframe)
df<- results("test.jsonl", "item.stance")
#> opening file input connection.
#>  Found 300 records... Imported 300 records. Simplifying...
#> closing file input connection.

# Metadata (Creates a Dataframe)
data <- metadata("test.jsonl")
#> opening file input connection.
#>  Found 300 records... Imported 300 records. Simplifying...
#> closing file input connection.

# Kappas (Creates a Dataframe)
kappa <- kappas(df, "item.stance")

# Confusion Matrix (Creates a List)
matrix <- cmatrix(df, "item.stance")

# Qwet AC1 (Creates a List)
qwets <- qwetAC1(df, "item.stance")
```

------------------------------------------------------------------------

## AI Disclourse

This project made limited use of artificial intelligence tools to
support development. Specifically, OpenAI’s ChatGPT-4o was used to:

> Generate a synthetic .jsonl dummy file for demonstration purposes – as
> the original files could not be shared due to privacy and GDPR
> concerns

> Decode and Troubleshoot errors during R package development and
> validation, as well as diagnosing and resolving Git-related errors
> encountered while setting up version control and publishing to GitHub.
