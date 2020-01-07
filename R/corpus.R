
#' Retrieve metadata for all plays in a corpus.
#'
#' The Dracor API lets you request data for plays for a specific corpus.
#' \code{get_corpus} returns \code{dracor} object that inherits
#' data.frame (and can be used as such) but specified \code{\link{summary}}
#' method and \code{\link{authors}} function.
#'
#' \code{get_corpus} returns a \code{dracor} object that inherits
#' data.frame (and can be used as such).
#'
#' \code{corpus} constructs \code{corpus} object
#'
#' You need to provide a valid name for the corpus, e.g. \code{"rus"},
#' \code{"ger"} or \code{"shake"}. Use function \code{\link{get_dracor}}
#' to extract names for all available corpora.
#'
#' @param corpus Name of the corpus (\code{name} column within an object
#'   returned by \code{\link{get_dracor}}).
#' @param URL Request URL.
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional metadata are retrieved.
#' @return \code{\link{dracor}} object that inherits data.frame (and can be used as such) but with additional
#' @examples
#' ru <- get_corpus("rus")
#' head(ru)
#' summary(ru)
#' @seealso \code{\link{get_dracor}}, \code{\link{authors}},
#'   \code{\link{get_dracor}}
#' @importFrom  jsonlite fromJSON
#' @export
get_corpus <- function(corpus =  NULL,
                       URL = paste0("https://dracor.org/api/corpora/", corpus),
                       full_metadata = TRUE) {
  if (is.null(corpus) & URL == "https://dracor.org/api/corpora/") {
    stop("You must provide corpus id or URL")
  } else {
    corp_list <- dracor_api(request = URL, expected_format = "application/json")
  }
  if (full_metadata) {
    corp_list$dramas <- merge(corp_list$dramas, fromJSON(paste0(URL, "/metadata"), flatten = TRUE))
  }
  corpus(corp_list)
}

#' @param corpus_list A list that is returned by \code{\link{get_dracor}}
#' @importFrom graphics abline axis par plot.default segments text
#' @importFrom utils type.convert
#' @exportClass corpus
#' @rdname get_corpus

corpus <- function(corpus_list){
  cor_df <- type.convert(corpus_list$dramas)
  structure(cor_df,
            name = corpus_list$name,
            title = corpus_list$title,
            repository = corpus_list$repository,
            class = c("corpus", class(cor_df)))
}

#' @param x An object to test.
#' @export
#' @rdname get_corpus
is.corpus <- function(x) {
  inherits(x, "corpus")
}


#' @param object An object for which a summary is desired.
#' @param ... Additional agruments.
#' @method summary corpus
#' @export
#' @rdname get_corpus
summary.corpus <- function(object, ...){
  written <- range(object$writtenYear, na.rm = T)
  premiere <- range(object$premiereYear, na.rm = T)
  printed <- range(object$printYear, na.rm = T)
  cat(sprintf("Written years (range): %d - %d", written[1], written[2]),
      sprintf("Premiere years (range): %d - %d", premiere[1], premiere[2]),
      sprintf("Years of the first printing (range): %d - %d", printed[1], printed[2]),
      sprintf("%d plays in %s", nrow(object), attr(object, "title")),
      sprintf("Corpus id: %s, repository: %s",
              attr(object, "name"),
              attr(object, "repository")),
      sep = "\t\n")
}
