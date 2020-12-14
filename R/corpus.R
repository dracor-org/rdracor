divide_years <- function(corpus, year_column) {
  setDT(corpus)
  if (!year_column %in% names(corpus))
    stop (paste("There is no such column as", year_column))
  written_years_list <-
    lapply(strsplit(as.character(corpus[[year_column]]), "/"), function(x)
      if (length(x) == 1)
        return(c(NA_character_, x))
      else
        return(x))
  corpus[, (paste0(year_column, "Start")) := suppressWarnings(as.integer(vapply(written_years_list, `[[`, "", 1)))]
  corpus[, (paste0(year_column, "Finish")) := suppressWarnings(as.integer(vapply(written_years_list, `[[`, "", 2)))]
  corpus[, (year_column) := NULL]
}

#' Retrieve metadata for all plays in a corpus.
#'
#' The DraCor API lets you request data for plays for a specific corpus.
#' \code{get_corpus} returns \code{dracor_meta} object that inherits
#' data.frame (and can be used as such) but specified \code{\link{summary}}
#' method and \code{\link{authors}} function.
#'
#' \code{get_corpus} returns a \code{corpus} object that inherits
#' data.frame (and can be used as such).
#
#' \code{get_corpus_all} returns metadata for all plays in all available
#' corpora as a long data.frame.
#'
#' \code{corpus} constructs \code{corpus} object, \code{is.corpus} tests that
#' object is \code{corpus}, \code{summary.corpus} returns informative summary
#' for a corpus.
#'
#' You need to provide a valid name for the corpus, e.g. \code{"rus"},
#' \code{"ger"} or \code{"shake"}. Use function \code{\link{get_dracor_meta}}
#' to extract names for all available corpora.
#'
#' @param corpus Name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor_meta}}).
#' @param URL Request URL.
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional metadata are retrieved.
#' @return \code{corpus} object that inherits data.frame (and can be used as such)
#' @examples
#' \donttest{
#' ru <- get_corpus("rus")
#' head(ru)
#' summary(ru)
#' }
#' @seealso \code{\link{get_dracor_meta}}, \code{\link{authors}}
#' @importFrom  jsonlite fromJSON
#' @import  data.table
#' @export
get_corpus <- function(corpus = NULL,
                       URL = paste0("https://dracor.org/api/corpora/", corpus),
                       full_metadata = TRUE) {
  subtitle <- NULL # to pass check
  columns_short_order <-
    c(
      "corpus",
      "id",
      "playName",
      "yearNormalized",
      "title",
      "subtitle",
      "firstAuthorName",
      "firstAuthorKey",
      "authors",
      "source",
      "sourceUrl",
      "writtenYearStart",
      "writtenYearFinish",
      "printYearStart",
      "printYearFinish",
      "premiereYearStart",
      "premiereYearFinish",
      "wikidataId" ,
      "networkSize",
      "networkdataCsvUrl"
    )
  columns_extra_order <- c(
    "size",
    "density",
    "diameter",
    "averageClustering",
    "averagePathLength",
    "averageDegree",
    "maxDegree",
    "maxDegreeIds",
    "numConnectedComponents",
    "wordCountSp",
    "wordCountText",
    "wordCountStage",
    "numOfSpeakers",
    "numOfSpeakersFemale",
    "numOfSpeakersMale",
    "numOfSpeakersUnknown",
    "numOfPersonGroups",
    "numOfSegments",
    "numOfActs",
    "wikipediaLinkCount",
    "genre"
  )
  if (is.null(corpus) & URL == "https://dracor.org/api/corpora/") {
    stop("You must provide corpus id or URL")
  } else {
    corp_list <-
      dracor_api(request = URL,
                 expected_type = "application/json",
                 flatten = TRUE)
    setDT(corp_list$dramas)
    corp_list$dramas[, corpus := corp_list$name]
    lapply(c("writtenYear", "printYear", "premiereYear"), function(x)
        divide_years(corp_list$dramas, x))
    if (!"subtitle" %in% names(corp_list$dramas))
      corp_list$dramas[, subtitle := NA_character_]
    data.table::setnames(
      corp_list$dramas,
      old = c("name", "author.name", "author.key"),
      new = c("playName", "firstAuthorName", "firstAuthorKey"),
      skip_absent = TRUE
    )
    data.table::setcolorder(corp_list$dramas,
                            neworder = columns_short_order)
  }
  if (full_metadata) {
    corp_list$dramas <-
      merge(
        corp_list$dramas,
        dracor_api(request = paste0(URL, "/metadata"), flatten = TRUE),
        by = "id",
        suffixes = c("", "Meta")
      )
    data.table::setcolorder(corp_list$dramas,
                            neworder = c(columns_short_order,
                                         columns_extra_order))
    dublicate_columns <-
      c(
        "name",
        "yearPremiered",
        "yearPrinted",
        "yearNormalizedMeta",
        "yearWritten",
        "playNameMeta"
      )
    corp_list$dramas[, (dublicate_columns) := NULL]
  }
  setDF(corp_list$dramas)
  corpus(corp_list)
}

#' @import data.table
#' @export
#' @rdname get_corpus
#' @examples
#' \donttest{
#' get_corpus_vec(c("ita", "span", "greek"))
#' }

get_corpus_vec <- function(corpus, full_metadata = TRUE) {
  corpus_list <- lapply(corpus, get_corpus)
  cor_df <- type.convert(data.table::rbindlist(corpus_list),
                         as.is = TRUE,
                         na.strings = c("NA", "-"))
  structure(cor_df,
            name = vapply(corpus_list, attr, "", "name"),
            title = vapply(corpus_list, attr, "", "title"),
            repository = vapply(corpus_list, attr, "", "repository"),
            plays = vapply(corpus_list, attr, 0, "plays"),
            class = c("corpus", class(cor_df)))
}

#' @import data.table
#' @export
#' @rdname get_corpus
#' @examples
#' \donttest{
#' get_corpus_all()
#' }
get_corpus_all <- function(full_metadata = TRUE) {
  dracor_meta <- get_dracor_meta()
  corpus_list <-
    lapply(dracor_meta$name,
           get_corpus,
           full_metadata = full_metadata)
  return(data.table::rbindlist(corpus_list))
}

#' @importFrom graphics abline axis par plot.default segments text
#' @importFrom utils type.convert
#' @exportClass corpus
corpus <- function(corpus_list) {
  cor_df <-
    type.convert(corpus_list$dramas,
                 as.is = TRUE,
                 na.strings = c("NA", "-"))
  structure(
    cor_df,
    name = corpus_list$name,
    title = corpus_list$title,
    repository = corpus_list$repository,
    plays = nrow(cor_df),
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
#' @describeIn get_corpus Meaningful summary for \code{dracor_meta} object.
summary.corpus <- function(object, ...) {
  written <-
    suppressWarnings(range(object$writtenYearStart, object$writtenYearFinish, na.rm = T))
  premiere <-
    suppressWarnings(range(
      object$premiereYearStart,
      object$premiereYearFinish,
      na.rm = T
    ))
  printed <-
    suppressWarnings(range(object$printYearStart, object$printYearFinish, na.rm = T))
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
      sprintf("Years of the first printing (range): %d - %d",
              printed[1],
              printed[2])
    },
    if (length(attr(object, "name")) == 1) {
    cat(sprintf("%d plays in %s", attr(object, "plays"), attr(object, "title")),
    sprintf(
      "Corpus id: %s, repository: %s",
      attr(object, "name"),
      attr(object, "repository")
    ),
    sep = "\t\n")} else {
    cat(sprintf("%d plays in %s corpora:", sum(attr(object, "plays")), length(attr(object, "name"))),
        "Corpora id:",
        paste(sprintf("%s (%i plays)", attr(object, "name"), attr(object, "plays")), collapse = ","),
      sep = "\t\n")
    },
    sep = "\t\n")
}
