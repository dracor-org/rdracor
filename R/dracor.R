divide_years <- function(dracor, year_column) {
  setDT(dracor)
  if (!year_column %in% names(dracor))
    stop (paste("There is no such column as", year_column))
  written_years_list <-
    lapply(strsplit(as.character(dracor[[year_column]]), "/"), function(x)
      if (length(x) == 1)
        return(c(NA_character_, x))
      else
        return(x))
  dracor[, (paste0(year_column, "Start")) := suppressWarnings(as.integer(vapply(written_years_list, `[[`, "", 1)))]
  dracor[, (paste0(year_column, "Finish")) := suppressWarnings(as.integer(vapply(written_years_list, `[[`, "", 2)))]
  dracor[, (year_column) := NULL]
}

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
    stop("You must provide dracor id or URL")
  } else {
    dracor_list <-
      dracor_api(request = URL,
                 expected_type = "application/json",
                 flatten = TRUE)
    setDT(dracor_list$dramas)
    dracor_list$dramas[, corpus := dracor_list$name]
    lapply(c("writtenYear", "printYear", "premiereYear"), function(x)
      divide_years(dracor_list$dramas, x))
    if (!"subtitle" %in% names(dracor_list$dramas))
      dracor_list$dramas[, subtitle := NA_character_]
    data.table::setnames(
      dracor_list$dramas,
      old = c("name", "author.name", "author.key"),
      new = c("playName", "firstAuthorName", "firstAuthorKey"),
      skip_absent = TRUE
    )
    data.table::setcolorder(dracor_list$dramas,
                            neworder = columns_short_order)
  }
  if (full_metadata) {
    dracor_list$dramas <-
      merge(
        dracor_list$dramas,
        dracor_api(request = paste0(URL, "/metadata"), flatten = TRUE),
        by = "id",
        suffixes = c("", "Meta")
      )
    data.table::setcolorder(dracor_list$dramas,
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
    dracor_list$dramas[, (dublicate_columns) := NULL]
  }
  setDF(dracor_list$dramas)
  dracor_list$plays <- nrow(dracor_list$dramas)
  return(dracor_list)
}

#' Retrieve metadata for all plays in selected corpora.
#'
#' The DraCor API lets you request data for plays for specific or all corpora.
#' \code{get_dracor} returns \code{dracor} object that inherits
#' data.frame (and can be used as such) but specified \code{\link{summary}}
#' method and \code{\link{authors}} function.
#'
#' \code{get_dracor} returns a \code{dracor} object that inherits
#' data.frame (and can be used as such).
#'
#' \code{dracor} constructs \code{dracor} object, \code{is.dracor} tests that
#' object is \code{dracor}, \code{summary.dracor} returns informative summary
#' for a dracor.
#'
#' You need to provide a vector with valid names of the corpora, e.g. \code{"rus"},
#' \code{"ger"} or \code{"shake"}. Use function \code{\link{get_dracor_meta}}
#' to extract names for all available corpora.
#'
#' @param corpus Character vector with names of the corpora (you can find all corpora names in
#'   \code{name} column within an object returned by \code{\link{get_dracor_meta}})
#'   or \code{"all"} (default value). if \code{"all"}, then all available corpora are downloaded
#' @param URL Request URL.
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional metadata are retrieved.
#' @return \code{dracor} object that inherits data.frame (and can be used as such).
#' @examples
#' \donttest{
#' ru <- get_dracor("rus")
#' head(ru)
#' summary(ru)
#' get_dracor(c("ita", "span", "greek"))
#' get_dracor()
#' }
#' @seealso \code{\link{get_dracor_meta}}, \code{\link{authors}}
#' @importFrom  jsonlite fromJSON
#' @import  data.table
#' @export
get_dracor <- function(corpus = "all",
                       URL = paste0("https://dracor.org/api/corpora/", corpus),
                       full_metadata = TRUE) {
  if (identical(corpus, "all")) {
    dracor_meta <- get_dracor_meta()
    corpus <- dracor_meta$name
  }
  dracor_list <- lapply(corpus, get_corpus, full_metadata = full_metadata)
  dracor(dracor_list)
}


#' @importFrom graphics abline axis par plot.default segments text
#' @importFrom utils type.convert
#' @exportClass dracor
dracor <- function(dracor_list) {
  dracor_df <- type.convert(
    data.table::rbindlist(lapply(dracor_list, `[[`, "dramas")),
    as.is = TRUE,
    na.strings = c("NA", "-")
  )
  structure(
    dracor_df,
    name = vapply(dracor_list, `[[`, "", "name"),
    title = vapply(dracor_list, `[[`, "", "title"),
    repository = vapply(dracor_list, `[[`, "", "repository"),
    plays = vapply(dracor_list, `[[`, 0, "plays"),
    class = c("dracor", "data.frame")
  )
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

#' @param object An object of class \code{dracor}.
#' @param ... Other arguments to be passed to \code{\link{summary.default}}.
#' @method summary dracor
#' @export
#' @describeIn get_dracor Meaningful summary for \code{dracor_meta} object.
summary.dracor <- function(object, ...) {
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
  cat(if (identical(written, c(Inf, -Inf))) {
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
    cat(
      sprintf(
        "%d plays in %s",
        attr(object, "plays"),
        attr(object, "title")
      ),
      sprintf(
        "Corpus id: %s, repository: %s",
        attr(object, "name"),
        attr(object, "repository")
      ),
      sep = "\t\n"
    )
  } else {
    cat(
      sprintf("%d plays in %s corpora:", sum(attr(object, "plays")), length(attr(object, "name"))),
      "Corpora id:",
      paste(sprintf(
        "%s (%i plays)", attr(object, "name"), attr(object, "plays")
      ), collapse = ","),
      sep = "\t\n"
    )
  },
  sep = "\t\n")
}
