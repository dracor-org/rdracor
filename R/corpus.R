#' @importFrom graphics abline axis par plot.default segments text
#' @importFrom utils type.convert
#' @exportClass corpus

corpus <- function(cor_fromjson){
  cor_df <- type.convert(cor_fromjson$dramas)
  structure(cor_df,
            name = cor_fromjson$name,
            title = cor_fromjson$title,
            repository = cor_fromjson$repository,
            class = c("corpus", class(cor_df)))
}

is.corpus <- function(x) {
  inherits(x, "corpus")
}


#' Retrieve metadata for all plays in a corpus.
#'
#' The Dracor API lets you request data for plays for a specific corpus. \code{get_corpus} returns \code{\link{dracor}} object that inherits data.frame.
#'
#' You need to provide a valid name for the corpus, e.g. \code{"rus"}, \code{"ger"} or \code{"shake"}. Use function \code{\link{get_dracor}} to extract names for all available corpora.
#'
#' @param corpus Name of the corpus (\code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param URL Request URL.
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional metadata are retrieved.
#' @return \code{\link{dracor}} object that inherits data.frame.
#' @examples
#' get_corpus("rus")
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

#' @method summary corpus
#' @export
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
