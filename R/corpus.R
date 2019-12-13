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

#' @importFrom  jsonlite fromJSON
#' @export
get_corpus <- function(name =  NULL,
                       URL = paste0("https://dracor.org/api/corpora/", name),
                       full_metadata = TRUE) {
  if (is.null(name)) {
    stop("You must provide name or URL")
  } else {
    corp_list <- fromJSON(URL, flatten = T)
  }
  if (full_metadata) {
    corp_list$dramas <- merge(corp_list$dramas, fromJSON(paste0(URL, "/metadata"), flatten = TRUE))
  }
  corpus(corp_list)
}

#' @exportMethod summary corpus
summary.corpus <- function(corpus){
  written <- range(corpus$writtenYear, na.rm = T)
  premiere <- range(corpus$premiereYear, na.rm = T)
  printed <- range(corpus$printYear, na.rm = T)
  cat(sprintf("Written years (range): %d - %d", written[1], written[2]),
      sprintf("Premiere years (range): %d - %d", premiere[1], premiere[2]),
      sprintf("Years of the first printing (range): %d - %d", printed[1], printed[2]),
      sprintf("%d plays in %s", nrow(corpus), attr(corpus, "title")),
      sprintf("Corpus id: %s, repository: %s",
              attr(corpus, "name"),
              attr(corpus, "repository")),
      sep = "\t\n")
}
