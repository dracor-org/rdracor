divide_years <- function(dracor, year_column) {
  data.table::setDT(dracor)
  if (!year_column %in% names(dracor)) {
    stop(paste("There is no such column as", year_column))
  }
  written_years_list <-
    lapply(strsplit(as.character(dracor[[year_column]]), "/"), function(x) {
      if (length(x) == 1) {
        return(c(NA_character_, x))
      } else {
        return(x)
      }
    })
  dracor[, (paste0(year_column, "Start")) := suppressWarnings(
    as.integer(vapply(written_years_list, `[[`, "", 1))
  )]
  dracor[, (paste0(year_column, "Finish")) := suppressWarnings(
    as.integer(vapply(written_years_list, `[[`, "", 2))
  )]
  dracor[, (year_column) := NULL]
  dracor[]
}

get_corpus <- function(corpus = NULL,
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
      "authors",
      "source",
      "sourceUrl",
      "writtenYearStart",
      "writtenYearFinish",
      "printYearStart",
      "printYearFinish",
      "premiereYearStart",
      "premiereYearFinish",
      "wikidataId",
      "networkSize",
      "networkdataCsvUrl"
    )
  columns_extra_order <- c(
    "normalizedGenre",
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
    "wikipediaLinkCount"
  )
  if (is.null(corpus)) {
    stop("You must provide dracor id")
  } else {
    dracor_list <-
      dracor_api(
        request = paste0("https://dracor.org/api/corpora/", corpus),
        expected_type = "application/json",
        flatten = TRUE,
        as_tibble = FALSE
      )
    data.table::setDT(dracor_list$dramas)
    lapply(c("writtenYear", "printYear", "premiereYear"), function(x) {
      divide_years(dracor_list$dramas, x)
    })
    if (!"subtitle" %in% names(dracor_list$dramas)) {
      dracor_list$dramas[, subtitle := NA_character_]
    }
    data.table::setnames(
      dracor_list$dramas,
      old = c("name", "author.name"),
      new = c("playName", "firstAuthorName"),
      skip_absent = TRUE
    )
    dracor_list$dramas[, corpus := dracor_list$name]
    data.table::setcolorder(dracor_list$dramas,
      neworder = columns_short_order
    )
  }
  if (isTRUE(full_metadata)) {
    dracor_list$dramas <-
      merge(
        dracor_list$dramas,
        dracor_api(request = paste0(
          "https://dracor.org/api/corpora/", corpus,
          "/metadata"
        ), flatten = TRUE),
        by = "id",
        suffixes = c("", "Meta")
      )
    data.table::setcolorder(dracor_list$dramas,
      neworder = c(
        columns_short_order,
        columns_extra_order
      )
    )
    dublicate_columns <-
      c(
        "name",
        "yearPremiered",
        "yearPrinted",
        "yearNormalizedMeta",
        "yearWritten",
        "playNameMeta",
        "titleMeta",
        "subtitleMeta"
      )
    dracor_list$dramas[, (dublicate_columns) := NULL]
  }
  dracor_list$plays <- nrow(dracor_list$dramas)
  return(dracor_list)
}


#' @importFrom graphics abline axis par plot.default segments text
#' @importFrom utils type.convert
#' @importFrom purrr map_chr map_int
#' @importFrom tibble as_tibble
#' @import  data.table
dracor <- function(dracor_list) {
  dracor_df <- tibble::as_tibble(type.convert(
    data.table::rbindlist(lapply(dracor_list, `[[`, "dramas"), fill = TRUE),
    as.is = TRUE,
    na.strings = c("NA", "-")
  ))
  structure(
    dracor_df,
    name = purrr::map_chr(dracor_list, "name"),
    title = purrr::map_chr(dracor_list, "title"),
    description = purrr::map_chr(dracor_list, "description"),
    repository = purrr::map_chr(dracor_list, "repository"),
    plays = purrr::map_int(dracor_list, "plays"),
    class = c("dracor", class(dracor_df))
  )
}

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
    suppressWarnings(range(object$writtenYearStart, object$writtenYearFinish,
      na.rm = TRUE
    ))
  premiere <-
    suppressWarnings(range(
      object$premiereYearStart,
      object$premiereYearFinish,
      na.rm = TRUE
    ))
  printed <-
    suppressWarnings(range(object$printYearStart, object$printYearFinish,
      na.rm = TRUE
    ))
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
      sprintf(
        "Years of the first printing (range): %d - %d",
        printed[1],
        printed[2]
      )
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
        sprintf(
          "Description: %s",
          attr(object, "description")
        ),
        sep = "\t\n"
      )
    } else {
      cat(
        sprintf(
          "%d plays in %s corpora:", sum(attr(object, "plays")),
          length(attr(object, "name"))
        ),
        "Corpora id:",
        paste(sprintf(
          "%s (%i plays)", attr(object, "name"), attr(object, "plays")
        ), collapse = ", "),
        sep = "\t\n"
      )
    },
    sep = "\t\n"
  )
}


#' Retrieve metadata for all plays in selected corpora
#'
#' \code{get_dracor()} request data on all plays in selected (or all) corpora.
#' \code{get_dracor()} returns \code{dracor} object that inherits
#' data frame (and can be used as such) but specified \code{\link{summary}}
#' method.
#'
#' You need to provide a vector with valid names of the corpora, e.g.
#' \code{"rus"}, \code{"ger"} or \code{"shake"}. Use function
#' \code{\link{get_dracor_meta}} to extract names for all available corpora.
#'
#' @param corpus Character vector with names of the corpora (you can find all
#' corpora names in \code{name} column within an object returned by
#' \code{\link{get_dracor_meta}}) or \code{"all"} (default value). if
#' \code{"all"}, then all available corpora are downloaded.
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional
#' metadata are retrieved.
#' @return \code{dracor} object that inherits data frame (and can be used as
#' such).
#' @examples
#' \donttest{
#' tat <- get_dracor("tat")
#' summary(tat)
#' get_dracor(c("ita", "span", "greek"))
#' get_dracor()
#' }
#' @seealso \code{\link{get_dracor_meta}}
#' @importFrom jsonlite fromJSON
#' @importFrom purrr compact map map_chr map_lgl safely
#' @import data.table
#' @export
get_dracor <- function(corpus = "all",
                       full_metadata = TRUE) {
  if (identical(corpus, "all")) {
    dracor_meta <- get_dracor_meta()
    corpus <- dracor_meta$name
  }
  available_corpora <- get_available_corpus_names()
  if (!all(corpus %in% available_corpora)) {
    stop(
      paste(
        "Corpus (corpora)",
        paste(setdiff(corpus, available_corpora), collapse = ", "),
        "do(es)n't exist(s)"
      )
    )
  }
  dracor_list <- purrr::map(corpus, purrr::safely(get_corpus),
    full_metadata = full_metadata
  )

  dracor_data_list <- dracor_list %>%
    purrr::map("result")

  dracor_empty_lgl <- dracor_data_list %>%
    purrr::map_lgl(is.null)

  if (any(dracor_empty_lgl)) {
    dracor_error <- dracor_list %>%
      purrr::map("error") %>%
      purrr::compact() %>%
      purrr::map_chr(as.character) %>%
      paste0(collapse = "")

    failed_corpora <- paste0(corpus[dracor_empty_lgl], collapse = ", ")
    warning(paste("\nDownload failed:", failed_corpora, "Error descriptions:",
      dracor_error,
      sep = "\n"
    ))
  }

  dracor_data_list %>%
    purrr::compact() %>%
    dracor()
}

#' Retrieve plays having a character identified by 'Wikidata ID'
#'
#' \code{get_character_plays()} requests plays that include a character that can
#' by found in 'Wikidata' by it's id. \code{get_character_plays()} sends a
#' request and parses the the result to get those plays as a data frame.
#'
#' @return Data frame, in which one row represents one play. Information on
#' author(s) name, character name, play name, URL and ID is represented in
#' separate columns.
#' @param char_wiki_id Character value with 'Wikidata ID' for a character.
#' 'Wikidata ID' can be found on \url{https://www.wikidata.org}. Character
#' vector (longer than 1) is not supported.
#' @examples
#' wiki_id <- "Q131412"
#' get_character_plays(wiki_id)
#' @seealso \code{\link{get_dracor}}
#' @export

get_character_plays <- function(char_wiki_id) {
  dracor_api(paste0("https://dracor.org/api/character/", char_wiki_id))
}
