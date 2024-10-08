% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shoddy_printer.R
\name{shoddy_printer}
\alias{shoddy_printer}
\title{Shoddy Printer: Simulate Poor Quality Printing for ggplot Objects}
\usage{
shoddy_printer(
  .plot,
  .dpi = 72,
  .width = NULL,
  .height = NULL,
  .noise_type = "gaussian",
  .file = NULL,
  .artifact_lines = FALSE,
  .bw_artifacts = TRUE,
  .low_contrast = TRUE
)
}
\arguments{
\item{.plot}{A ggplot object.}

\item{.dpi}{The DPI for the image (default: 72). Lower DPI simulates poor printing quality.}

\item{.width}{Width of the plot in inches (default: NULL). If NULL, attempts to retrieve from `dev.size()`; falls back to 16.}

\item{.height}{Height of the plot in inches (default: NULL). If NULL, attempts to retrieve from `dev.size()`; falls back to 9.}

\item{.noise_type}{The type of noise to add (default: "gaussian"). Options include "gaussian", "multiplicative", etc.}

\item{.file}{Optional. If NULL (default), the image will not be saved to a file.
If a file path is provided, the image will be saved at that location.}

\item{.artifact_lines}{Logical. If TRUE, adds random artifact lines or blotches (default: FALSE).}

\item{.bw_artifacts}{Logical. If TRUE, simulates black-and-white printing artifacts (default: TRUE).}

\item{.low_contrast}{Logical. If TRUE, reduces contrast for text and legends (default: TRUE).}
}
\value{
A ggplot object with the PNG as a rasterGrob.
}
\description{
This function takes a ggplot object, reduces the DPI, converts it to grayscale,
adds noise, and simulates poor printing quality with various artifacts such as
black-and-white printing artifacts, low-contrast text, and artifact lines or blotches.
The resulting image is returned as a rasterGrob embedded in a ggplot object.
}
\examples{
p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point(ggplot2::aes(color = factor(gear))) +
    ggplot2::theme_minimal()
shoddy_printer(p)
}
