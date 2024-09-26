#' Shoddy Printer: Simulate Poor Quality Printing for ggplot Objects
#'
#' This function takes a ggplot object, reduces the DPI, converts it to grayscale,
#' adds noise, and simulates poor printing quality with various artifacts such as
#' black-and-white printing artifacts, low-contrast text, and artifact lines or blotches.
#' The resulting image is returned as a rasterGrob embedded in a ggplot object.
#'
#' @param .plot A ggplot object.
#' @param .dpi The DPI for the image (default: 72). Lower DPI simulates poor printing quality.
#' @param .width Width of the plot in inches (default: NULL). If NULL, attempts to retrieve from `dev.size()`; falls back to 16.
#' @param .height Height of the plot in inches (default: NULL). If NULL, attempts to retrieve from `dev.size()`; falls back to 9.
#' @param .noise_type The type of noise to add (default: "gaussian"). Options include "gaussian", "multiplicative", etc.
#' @param .file Optional. If NULL (default), the image will not be saved to a file.
#'   If a file path is provided, the image will be saved at that location.
#' @param .artifact_lines Logical. If TRUE, adds random artifact lines or blotches (default: FALSE).
#' @param .bw_artifacts Logical. If TRUE, simulates black-and-white printing artifacts (default: TRUE).
#' @param .low_contrast Logical. If TRUE, reduces contrast for text and legends (default: TRUE).
#'
#' @return A ggplot object with the PNG as a rasterGrob.
#' @examples
#' p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
#'     ggplot2::geom_point(ggplot2::aes(color = factor(gear))) +
#'     ggplot2::theme_minimal()
#' shoddy_printer(p)
#' @export
shoddy_printer <- function(.plot, .dpi = 72, .width = NULL, .height = NULL, .noise_type = "gaussian",
                           .file = NULL, .artifact_lines = FALSE, .bw_artifacts = TRUE,
                           .low_contrast = TRUE) {

  # If .width or .height are NULL, get the current device size using dev.size(), fallback to 16:9
  if (is.null(.width) || is.null(.height)) {
    dev_dims <- dev.size("in")  # Get the current device size in inches
    if (!is.null(dev_dims) && length(dev_dims) == 2) {
      .width <- ifelse(is.null(.width), dev_dims[1], .width)
      .height <- ifelse(is.null(.height), dev_dims[2], .height)
    } else {
      # Fallback to 16:9 ratio
      .width <- 16
      .height <- 9
    }
  }

  # Temporarily save the plot with specified DPI, width, and height
  temp_file <- tempfile(fileext = ".png")
  ggplot2::ggsave(temp_file, plot = .plot, dpi = .dpi, width = .width, height = .height)

  # Load the saved image using magick
  img <- suppressMessages(magick::image_read(temp_file))

  # Convert to grayscale
  img_gray <- magick::image_convert(img, colorspace = "gray")

  # Add noise
  img_noisy <- magick::image_noise(img_gray, .noise_type)

  # Add black-and-white printing artifacts with a moderate setting
  if (.bw_artifacts) {
    img_noisy <- magick::image_quantize(img_noisy, colorspace = "gray", max = 64)
  }

  # Add artifact lines or blotches
  if (.artifact_lines) {
    img_noisy <- magick::image_annotate(img_noisy, "_____", location = "+50+50", color = "black", size = 20)
    img_noisy <- magick::image_blur(img_noisy, radius = 2, sigma = 1.5)
  }

  # Reduce contrast for text and legends
  if (.low_contrast) {
    img_noisy <- magick::image_contrast(img_noisy, sharpen = 0)
  }

  # Save to file if file path is provided
  if (!is.null(.file)) {
    magick::image_write(img_noisy, .file)
  }

  # Convert the image to rasterGrob
  img_raster <- grid::rasterGrob(as.raster(img_noisy), interpolate = TRUE)

  # Create a ggplot object to return the rasterGrob
  gg_raster <- ggplot2::ggplot() +
    ggplot2::annotation_custom(img_raster, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
    ggplot2::theme_void()

  return(gg_raster)
}


