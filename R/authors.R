# helper functions ---
shortening_names <- function(name) {
  vapply(lapply(strsplit(name, ","),
                function(x)
                  c(x[1], gsub(
                    "[[:lower:]]+", "", x[-1]
                  ))), paste, "", collapse = ",")
}


top_authors <- function(authors, top_n = 5) {
  authors_short <- authors[1:min(nrow(authors), top_n), ]
  paste(authors_short$plays,
    authors_short$name,
    sep = " - ",
    collapse = "\t\n"
  )
}

# functions for export

#' Retrieve authors and number of plays they have for a corpus
#'
#' \code{authors} returns \code{authors} object that inherits data.frame. For
#' each author in a corpus her/his respective number of plays is calculated.
#'
#' There are more than one author for a play in some cases (e.g., in German
#' Drama Corpus). Coauthorship is not "weighted" for these plays: for each
#' author a play is counted as one play. Thus, a sum of all plays by al writers
#' in \code{authors} can be more than a number of plays in a corpus.
#'
#' @return \code{authors} object that inherits data.frame (and can be used
#'   as such).
#' @param corpus \code{corpus} object or corpus name as character. Vector of corpus
#'   names is not supported
#' @examples
#' ru <- get_corpus("rus")
#' ru_authors <- authors(ru)
#' summary(ru_authors)
#' @seealso \code{\link{is.authors}}, \code{\link{plot.authors}},
#' \code{\link{get_dracor}}
#' @import data.table
#' @exportClass authors
#' @export
authors <- function(corpus) {
  plays <- N <- name <- `.` <- NULL # to pass check
  if (is.character(corpus)) {
    corpus <- get_corpus(corpus)
  } else if (is.corpus(corpus)) {
    invisible()
  } else {
    stop("corpus parameter is neither valid corpus name nor corpus object")
  }
  authors_dt <-
    data.table::rbindlist(corpus$authors)[, .(plays = .N), by = .(key, name)][order(-plays)]
  structure(
    authors_dt,
    name = attr(corpus, "name"),
    title = attr(corpus, "title"),
    repository = attr(corpus, "repository"),
    class = c("authors", "data.frame")
  )
}

#' Test an object to be an 'authors' object.
#'
#' Test that object is an \code{\link{authors}}.
#'
#' @param x An R object.
#' @seealso \code{\link{authors}}
#' @export
is.authors <- function(x) {
  inherits(x, "authors")
}

#' @param object An object of class \code{"authors"}.
#' @param ... Other arguments to be passed to \code{\link{summary.default}}.
#' @method summary authors
#' @export
#' @describeIn authors Meaningful summary for \code{authors} object
summary.authors <- function(object, ...) {
  n <- nrow(object)
  cat(
    sprintf(
      "There are %d authors in %s\t\n\nTop authors of the Corpus:\t\n%s",
      n,
      attr(object, "title"),
      top_authors(object)
    )
  )
}

#' Plot number of plays by authors of the corpus
#'
#' \code{plot.authors} plots numbers of plays for every author or only for
#' top authors.
#'
#' There are some really long names, in case you want to plot authors with their
#' surnames only, use \code{only_surnames = TRUE}.
#' For large corpora, e.g., German Drama Corpus or Russian Drama Corpus,
#' there is a problem of overplotting. You can plot only top authors by
#' parameters \code{top_n}, \code{top_minplays}, or \code{top_ratio}
#' adjustment.
#'
#' @param x \code{authors} object to plot.
#' @param abbreviate_names Logical, if \code{TRUE}, then authors' names
#'   are shown abbreviated, defaults to \code{FALSE}.
#' @param top_n Integer, number of top authors to show on plot.
#' @param top_minplays Integer, minimum number of plays for an author to be
#'   plotted.
#' @param top_ratio Numeric, from 0 to 1, maximum ratio of top authors to be
#'   plotted. For example, with \code{top_ratio = 0.1} maximum 10\% of top
#'   authors will be plotted.
#' @param ... Other parameters to be passed to \code{\link{plot.default}}.
#' @examples
#' rus <- get_corpus("rus")
#' rus_authors <- authors(rus)
#' plot(rus_authors, top_minplays = 4)
#' @method plot authors
#' @export
plot.authors <- function(x,
                         abbreviate_names = FALSE,
                         top_n = nrow(x),
                         top_minplays = 1,
                         top_ratio = 1,
                         ...) {
  if (abbreviate_names) {
    x$name <- shortening_names(x$name)
  }
  top_authors <- min(
    ceiling(top_ratio * nrow(x)),
    top_n,
    nrow(x[x$plays >= top_minplays, ])
  )
  x <- x[1:top_authors, ]
  pch <- 16
  col <- "black"
  lty.lolly <- 1
  lty.baseline <- 2
  cex <- 0.8
  left_margin <- 14
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
    main = "Number of plays for each author",
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
    labels = x$name,
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
