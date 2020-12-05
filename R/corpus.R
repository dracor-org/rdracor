

#' Retrieve metadata for all plays in a corpus.
#'
#' The DraCor API lets you request data for plays for a specific corpus.
#' \code{get_corpus} returns \code{dracor} object that inherits
#' data.frame (and can be used as such) but specified \code{\link{summary}}
#' method and \code{\link{authors}} function.
#'
#' \code{get_corpus} returns a \code{corpus} object that inherits
#' data.frame (and can be used as such).
#'
#' \code{corpus} constructs \code{corpus} object, \code{is.corpus} tests that
#' object is \code{corpus}, \code{summary.corpus} returns informative summary
#' for a corpus.
#'
#' You need to provide a valid name for the corpus, e.g. \code{"rus"},
#' \code{"ger"} or \code{"shake"}. Use function \code{\link{get_dracor}}
#' to extract names for all available corpora.
#'
#' @param corpus Name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param URL Request URL.
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional metadata are retrieved.
#' @return \code{corpus} object that inherits data.frame (and can be used as such)
#' @examples
#' ru <- get_corpus("rus")
#' head(ru)
#' summary(ru)
#' @seealso \code{\link{get_dracor}}, \code{\link{authors}}
#' @importFrom  jsonlite fromJSON
#' @importFrom  data.table setnames
#' @export
get_corpus <- function(corpus = NULL,
                       URL = paste0("https://dracor.org/api/corpora/", corpus),
                       full_metadata = TRUE) {
  if (is.null(corpus) & URL == "https://dracor.org/api/corpora/") {
    stop("You must provide corpus id or URL")
  } else {
    corp_list <-
      dracor_api(request = URL,
                 expected_type = "application/json",
                 flatten = TRUE)
    written_years_list <-
      lapply(strsplit(as.character(corp_list$dramas$writtenYear), "/"), function(x)
        if (length(x) == 1)
          return(c(NA_character_, x))
        else
          return(x))
    corp_list$dramas$writtenYearStart <-
      vapply(written_years_list, `[[`, "", 1)
    corp_list$dramas$writtenYearFinish <-
      vapply(written_years_list, `[[`, "", 2)
    corp_list$dramas$writtenYear <- NULL
    data.table::setnames(
      corp_list$dramas,
      old = c("name", "author.name", "author.key"),
      new = c("playName", "firstAuthorName", "firstAuthorKey"),
      skip_absent = TRUE
    )
  }
  if (full_metadata) {
    corp_list$dramas <-
      merge(corp_list$dramas,
            dracor_api(request = paste0(URL, "/metadata"), flatten = TRUE))
  }
  corpus(corp_list)
}

#' @importFrom graphics abline axis par plot.default segments text
#' @importFrom utils type.convert
#' @exportClass corpus
corpus <- function(corpus_list) {
  cor_df <- type.convert(corpus_list$dramas, as.is = TRUE, na.strings = c("NA", "-"))
  structure(
    cor_df,
    name = corpus_list$name,
    title = corpus_list$title,
    repository = corpus_list$repository,
    class = c("corpus", class(cor_df))
  )
}

#' Test an object to be a 'corpus' object.
#'
#' Test that object is a \code{corpus}.
#'
#' @param x An R object.
#' @seealso \code{\link{get_corpus}}
#' @export
is.corpus <- function(x) {
  inherits(x, "corpus")
}

#' @param object An object of class \code{"corpus"}.
#' @param ... Other arguments to be passed to \code{\link{summary.default}}.
#' @method summary corpus
#' @export
#' @describeIn get_corpus Meaningful summary for \code{dracor} object.
summary.corpus <- function(object, ...) {
  written <- suppressWarnings(range(object$writtenYear, na.rm = T))
  premiere <- suppressWarnings(range(object$premiereYear, na.rm = T))
  printed <- suppressWarnings(range(object$printYear, na.rm = T))
  cat(
    if (identical(written, c(Inf, -Inf))) {
      "No information on written years"
    } else {
      sprintf("Written years (range): %d - %d", written[1], written[2])
    },
    if (identical(premiere, c(Inf, -Inf))) {
      "No information on premiere years"
    } else {
      sprintf("Premiere years (range): %d - %d", premiere[1], premiere[2])
    },
    if (identical(printed, c(Inf, -Inf))) {
      "No information on years of the first printing"
    } else {
      sprintf("Years of the first printing (range): %d - %d", printed[1], printed[2])
    },
    sprintf("%d plays in %s", nrow(object), attr(object, "title")),
    sprintf(
      "Corpus id: %s, repository: %s",
      attr(object, "name"),
      attr(object, "repository")
    ),
    sep = "\t\n"
  )
}
