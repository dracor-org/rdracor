form_play_request <-
  function(play = NULL,
           corpus = NULL,
           type = NULL) {
    stopifnot(is.character(corpus) && length(corpus) == 1)
    stopifnot(is.character(play) && length(play) == 1)
    request <-
      paste0("https://dracor.org/api/corpora/", corpus, "/play/", play)
    if (!is.null(type)) {
      return(paste(request, type, sep = "/"))
    } else {
      return(request)
    }
  }

#' @import httr
dracor_error <- function(resp) {
  if (resp$status_code == 404) {
    stop(
      sprintf(
        "Status code - %i: Wrong Dracor API request - data were not found",
        resp$status_code
      )
    )
  } else if (resp$status_code == 400) {
    stop(
      sprintf(
        "Status code - %i: Wrong Dracor API request - invalid request",
        resp$status_code
      )
    )
  } else if (resp$status_code >= 500) {
    stop(sprintf(
      "Status code - %i: Internal Dracor server problem",
      resp$status_code
    ))
  } else if (resp$status_code != 200) {
    stop(sprintf("Status code - %i: Unknown problem", resp$status_code))
  }
}

#' Send a GET request to DraCor API and parse the results
#'
#' Sending a GET request to DraCor API with a specified expected type and parse
#' results depending on selected expected type.
#'
#' There are four different MIME types (aka internet media type) that can be
#' retrieved for DraCor API, the specific combination of possible MIME types
#' depends on API command. When \code{parse = TRUE} is used, the content is
#' parsed depending on selected MIME type in \code{expected_type}:
#' \describe{
#'   \item{\code{application/json}}{\code{\link[jsonlite:fromJSON]{jsonlite::fromJSON()}}}
#'   \item{\code{application/xml}}{\code{\link[xml2:read_xml]{xml2::read_xml()}}}
#'   \item{\code{text/csv}}{\code{\link[data.table:fread]{data.table::fread()}}}
#'   \item{\code{text/plain}}{No need for additional preprocessing}}
#'
#' @param request Character, valid GET request.
#' @param expected_type Character, MIME type: one of \code{"application/json"},
#'   \code{"application/xml"}, \code{"text/csv"}, \code{"text/plain"}.
#' @param parse Logical, if \code{TRUE} (default value), then a response is parsed depending on
#'   \code{expected_type}. See details below.
#' @param default_type Logical, if \code{TRUE}, default response data type is
#'   returned. Therefore, a response is not parsed and \code{parse} is ignored.
#'   Default value is \code{FALSE}.
#' @param split_text Logical, if \code{TRUE}, plain text lines are read as
#'   different values in a vector instead of returning one character value.
#'   Default value is \code{TRUE}.
#' @param as_tibble Logical, if \code{TRUE}, data.frame will be returned as a
#'   tidyverse tibble (\code{tbl_df}). Default value is \code{TRUE}.
#' @param ... Other arguments passed to a parser function.
#' @import httr
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @import xml2
#' @import data.table
#' @export
dracor_api <- function(request,
                       expected_type =
                         c(
                           "application/json",
                           "application/xml",
                           "text/csv",
                           "text/plain"
                         ),
                       parse = TRUE,
                       default_type = FALSE,
                       split_text = TRUE,
                       as_tibble = TRUE,
                       ...) {
  expected_type <- match.arg(expected_type)
  if (default_type) {
    resp <- httr::GET(request)
    return(httr::content(resp, as = "text", encoding = "UTF-8"))
  } else {
    resp <- httr::GET(request, httr::accept(expected_type))
  }
  dracor_error(resp)
  cont <- httr::content(resp, as = "text", encoding = "UTF-8")
  if (!parse) {
    return(cont)
  }
  switch(expected_type,
    "application/json" = if (as_tibble) {
      return(tibble::as_tibble(jsonlite::fromJSON(cont, ...)))
    } else {
      return(jsonlite::fromJSON(cont, ...))
    },
    "application/xml" = return(xml2::read_xml(cont, ...)),
    "text/csv" = if (as_tibble) {
      return(tibble::as_tibble(data.table::fread(cont, ...)))
    } else {
      return(data.table::fread(cont, ...))
    },
    "text/plain" = if (split_text) {
      return(unlist(strsplit(cont, "\n")))
    } else {
      return(cont)
    }
  )
}

#' Submit SPARQL queries to DraCor API.
#'
#' The DraCor API lets you submit SPARQL queries.
#'
#' @return SPARQL xml parsed.
#' @param sparql_query Character, SPARQL query.
#' of specified gender: \code{"MALE"}, \code{"FEMALE"}, \code{"UNKNOWN"}.
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @inheritParams get_play_metadata
#' @examples
#' dracor_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10")
#' # If you want to avoid parsing by xml2::read_xml():
#' dracor_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10", parse = FALSE)
#' @importFrom utils URLencode
#' @export
dracor_sparql <- function(sparql_query = NULL, parse = TRUE, ...) {
  if (is.null(sparql_query)) {
    stop("SPARQL query must be provided")
  }
  query <- paste0(
    "https://dracor.org/fuseki/sparql?query=",
    URLencode(sparql_query, reserved = TRUE)
  )
  dracor_api(query, expected_type = "application/xml", parse = parse, ...)
}

#' Retrieve Dracor API info.
#'
#' \code{dracor_api_info} returns information about DraCor API: name of
#' the API, status, existdb version, and API version.
#'
#' No parameters are expected.
#'
#' @examples
#' dracor_api_info()
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
dracor_api_info <- function() {
  tibble::as_tibble(dracor_api("https://dracor.org/api/info", expected_type = "application/json"))
}
