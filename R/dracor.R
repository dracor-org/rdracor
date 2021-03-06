#' Retrieve Dracor API info.
#'
#' \code{get_dracor_api_info} returns information about DraCor API: name of
#' the API, status, existdb version, and API version.
#'
#' No parameters are expected.
#'
#' @examples
#' get_dracor_api_info()
#' @importFrom jsonlite fromJSON
#' @export
get_dracor_api_info <- function() {
  as.data.frame(dracor_api("https://dracor.org/api/info", expected_type = "application/json"))
}

#' Retrieve information on available corpora.
#'
#' \code{get_dracor} returns a \code{dracor} object that inherits
#' data.frame (and can be used as such).
#'
#' @return \code{dracor} object that inherits data.frame (and can be used
#'   as such).
#' @examples
#' corpora <- get_dracor()
#' corpora
#' summary(corpora)
#' plot(corpora)
#' @seealso
#' \code{\link{is.dracor}}, \code{\link{get_corpus}}
#' @export
get_dracor <-
  function() {
    dracor(
      dracor_api(
        "https://dracor.org/api/corpora?include=metrics",
        expected_type = "application/json",
        flatten = TRUE
      )
    )
  }

#' @exportClass dracor
dracor <- function(dracor_df) {
  dracor <- type.convert(dracor_df, as.is = TRUE)
  names(dracor) <- gsub("metrics.", "", names(dracor), fixed = TRUE)
  dracor$updated <-
    as.POSIXct(dracor$updated, format = "%FT%H:%M:%OS", tz = "UTC")
  dracor <- dracor[order(-dracor$plays), ]
  attributes(dracor) <- c(
    attributes(dracor),
    get_dracor_api_info()
  )
  class(dracor) <- c("dracor", class(dracor))
  return(dracor)
}

#' Test an object to be a 'dracor' object.
#'
#' Test that object is a \code{dracor}.
#'
#' @param x An R object.
#' @seealso \code{\link{get_dracor}}
#' @export
is.dracor <- function(x) {
  inherits(x, "dracor")
}

#' @param object An object of class \code{"dracor"}.
#' @param ... Other arguments to be passed.
#' @method summary dracor
#' @export
#' @describeIn get_dracor Meaningful summary for \code{dracor} object.
summary.dracor <- function(object, ...) {
  n_plays <- sum(object$plays)
  n_corpora <- nrow(object)
  last_upd <- which.max(object$updated)
  cat(
    sprintf("DraCor hosts %d corpora comprising %d plays.", n_corpora, n_plays),
    sprintf(
      "The last updated corpus was %s (%s).",
      object$title[last_upd],
      object$updated[last_upd]
    ),
    sep = "\n\n"
  )
}

#' @param x A \code{dracor} object.
#' @method plot dracor
#' @export
#' @describeIn get_dracor Plots how many plays are
#' available for each corpus.
plot.dracor <- function(x,
                        ...) {
  pch <- 16
  col <- "black"
  lty.lolly <- 1
  lty.baseline <- 2
  cex <- 0.8
  left_margin <- 10.5
  y_in <- rev(1:nrow(x))
  old.par <- par(no.readonly = TRUE)
  par(
    mar = c(3, left_margin, 4, 2) + 0.1,
    mgp = c(2, 1, 0)
  )
  plot.default(
    x$plays,
    y_in,
    pch = pch,
    main = "Number of plays for each corpus",
    cex.main = 1,
    xlab = "Plays",
    ylab = NA,
    xlim = c(0, max(x$plays) * 1.2),
    yaxt = "n",
    col = col,
    lty = lty.lolly,
    ...
  )
  axis(
    2,
    at = y_in,
    labels = x$title,
    las = 1,
    cex.axis = cex,
    gap.axis = -1
  )
  segments(0, y_in, x$plays, y_in, col = col)
  text(
    x$plays + 0.1 * max(x$plays),
    y_in,
    labels = x$plays,
    col = col,
    cex = cex
  )
  par(old.par)
}
