#' Retrieve information on available corpora
#'
#' \code{get_dracor_meta()} returns metadata on available corpora as a
#' \code{dracor_meta} object that inherits data frame (and can be used as such).
#' Use \code{summary()} and \code{plot()} on this object to get an even more
#' condensed summary.
#'
#' @return \code{dracor_meta} object that inherits data frame (and can be used
#'   as such).
#' @examples
#' corpora_meta <- get_dracor_meta()
#' corpora_meta
#' summary(corpora_meta)
#' plot(corpora_meta)
#' @seealso
#' \code{\link{get_dracor}}
#' @export
get_dracor_meta <-
  function() {
    dracor_meta(
      dracor_api(
        "https://dracor.org/api/corpora?include=metrics",
        expected_type = "application/json",
        flatten = TRUE
      )
    )
  }


get_available_corpus_names <- function() {
  get_dracor_meta()$name
}

dracor_meta <- function(dracor_df) {
  dracor_meta <-
    type.convert(dracor_df,
      as.is = TRUE,
      na.strings = c("NA", "-")
    )
  names(dracor_meta) <-
    gsub("metrics.", "", names(dracor_meta), fixed = TRUE)
  dracor_meta$updated <-
    as.POSIXct(dracor_meta$updated, format = "%FT%H:%M:%OS", tz = "UTC")
  dracor_meta <- dracor_meta[order(-dracor_meta$plays), ]
  attributes(dracor_meta) <- c(
    attributes(dracor_meta),
    dracor_api_info()
  )
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

  axis(
    side = 2,
    at = y_in,
    labels = x$title,
    las = 1,
    cex.axis = cex,
    gap.axis = -1
  )

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
