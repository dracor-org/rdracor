#' Retrieve information on available corpora
#'
#' \code{get_dracor_meta()} returns metadata on available corpora as a
#' \code{dracor_meta} object that inherits data frame (and can be used as such).
#' Use \code{summary()} and \code{plot()} on this object to get an even more
#' condensed summary.
#'
#' @return \code{dracor_meta} object that inherits data frame (and can be used
#'   as such).
#' @examplesIf dracor_api_available()
#' corpora_meta <- get_dracor_meta()
#' corpora_meta
#' summary(corpora_meta)
#' plot(corpora_meta)
#' @seealso
#' \code{\link{get_dracor}}
#' @export
get_dracor_meta <-
  function() {
    corpora <- dracor_api(
      paste0(get_dracor_api_url(), "/corpora?include=metrics"),
      expected_type = "application/json",
      flatten = TRUE
    )
    if (is.null(corpora)) {
      return(invisible(NULL))
    }
    dracor_meta(corpora)
  }


get_available_corpus_names <- function() {
  get_dracor_meta()$name
}

# 'DraCor' API gives timestamps like "2026-10-07T03:32:39.834+02:00". The UTC
# offset is taken into account (R's %z needs it without the colon); timestamps
# without an offset are read as UTC.
parse_dracor_datetime <- function(x) {
  x <- sub("([+-][0-9]{2}):([0-9]{2})$", "\\1\\2", x)
  out <- as.POSIXct(x, format = "%FT%H:%M:%OS%z", tz = "UTC")
  no_offset <- is.na(out) & !is.na(x)
  out[no_offset] <- as.POSIXct(x[no_offset], format = "%FT%H:%M:%OS", tz = "UTC")
  out
}

dracor_meta <- function(dracor_df) {
  dracor_meta <-
    type.convert(dracor_df,
      as.is = TRUE,
      na.strings = c("NA", "-")
    )
  names(dracor_meta) <-
    gsub("metrics.", "", names(dracor_meta), fixed = TRUE)
  dracor_meta$updated <- parse_dracor_datetime(dracor_meta$updated)
  dracor_meta <- dracor_meta[order(-dracor_meta$plays), ]
  class(dracor_meta) <- c("dracor_meta", class(dracor_meta))
  return(dracor_meta)
}

is.dracor_meta <- function(x) {
  inherits(x, "dracor_meta")
}

#' @param object An object of class \code{"dracor_meta"}.
#' @param ... Other arguments to be passed.
#' @method summary dracor_meta
#' @export
#' @describeIn get_dracor_meta Meaningful summary for \code{dracor_meta} object.
summary.dracor_meta <- function(object, ...) {
  n_plays <- sum(object$plays)
  n_corpora <- nrow(object)
  last_upd <- which.max(object$updated)
  cat(
    sprintf(
      "DraCor hosts %d corpora comprising %d plays.",
      n_corpora,
      n_plays
    ),
    sprintf(
      "The last updated corpus was %s (%s).",
      object$title[last_upd],
      object$updated[last_upd]
    ),
    sep = "\n\n"
  )
}

#' @param x A \code{dracor_meta} object.
#' @method plot dracor_meta
#' @export
#' @describeIn get_dracor_meta Plots how many plays are
#' available for each corpus.
plot.dracor_meta <- function(x,
                             ...) {
  y_in <- rev(seq_len(nrow(x)))
  pch <- 16
  lty <- 1
  cex <- 0.8
  left_margin <- 13

  oldpar <- par(no.readonly = TRUE)
  on.exit(par(oldpar))

  par(
    mar = c(3, left_margin, 4, 2) + 0.1,
    mgp = c(2, 1, 0)
  )

  plot.default(
    x = x$plays,
    y = y_in,
    pch = pch,
    main = "Number of plays for each corpus",
    xlab = "Plays",
    ylab = NA,
    xlim = c(0, max(x$plays) * 1.2),
    yaxt = "n",
    lty = lty
  )

  axis_args <- list(
    side = 2,
    at = y_in,
    labels = x$title,
    las = 1,
    cex.axis = cex
  )
  # gap.axis = -1 keeps all labels even if they overlap; the argument
  # appeared in R 4.0
  if (getRversion() >= "4.0.0") axis_args$gap.axis <- -1
  do.call(axis, axis_args)

  segments(x0 = 0,
           y0 = y_in,
           x1 = x$plays,
           y1 = y_in)

  text(
    x = x$plays + 0.1 * max(x$plays),
    y = y_in,
    labels = x$plays,
    cex = cex
  )
}
