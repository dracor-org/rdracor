form_play_request <-
  function(play = NULL,
           corpus = NULL,
           type = NULL) {
    stopifnot(is.character(corpus) && length(corpus) == 1)
    stopifnot(is.character(play) && length(play) == 1)
    request <-
      paste0(get_dracor_api_url(), "/corpora/", corpus, "/plays/", play)
    if (!is.null(type)) {
      return(paste(request, type, sep = "/"))
    } else {
      return(request)
    }
  }

#' @import httr
dracor_error <- function(resp) {
  status <- httr::status_code(resp)
  problem <- if (status == 404) {
    paste(
      "data were not found. Check corpus and play names;",
      "some data (e.g. relations) are not available for every play"
    )
  } else if (status == 400) {
    "invalid request"
  } else if (status >= 500) {
    "internal 'DraCor' server problem"
  } else {
    "unknown problem"
  }
  message(sprintf("Status code - %i: %s\nRequest: %s", status, problem, resp$url))
  invisible(NULL)
}

#' Send a GET request to DraCor API and parse the results
#'
#' Function \code{dracor_api()} sends a GET request to DraCor API with a
#' specified expected type and parses results depending on selected expected
#' type.
#'
#' There are four different 'MIME' types (aka internet media type) that can be
#' retrieved for DraCor API, the specific combination of possible 'MIME' types
#' depends on API command. When \code{parse = TRUE} is used, the content is
#' parsed depending on selected 'MIME' type in \code{expected_type}:
#' \describe{
#'   \item{\code{application/json}}{\code{
#'   \link[jsonlite:fromJSON]{jsonlite::fromJSON()}}}
#'   \item{\code{application/xml}}{\code{\link[xml2:read_xml]{xml2::read_xml()}}}
#'   \item{\code{text/csv}}{\code{\link[data.table:fread]{data.table::fread()}}}
#'   \item{\code{text/plain}}{No need for additional preprocessing}}
#'
#' If 'DraCor' API is not available (no internet connection, the server is down
#' or does not respond within the time limits, see below), returns an error
#' status or data that cannot be parsed, \code{dracor_api()} does not throw an
#' error: it shows an informative message and returns \code{NULL} invisibly.
#' All functions of the package that request data from 'DraCor' API behave the
#' same way.
#'
#' @section Time limits:
#' Two time limits apply to every request to 'DraCor' API. Both can be changed
#' with \code{\link{options}()}:
#' \describe{
#'   \item{\code{rdracor.connect_timeout}}{Seconds to wait for the connection
#'   to the server, 30 by default. If the server does not accept the connection
#'   within this time, it is treated as unavailable.}
#'   \item{\code{rdracor.timeout}}{Seconds to wait for the whole response,
#'   600 (10 minutes) by default. Some requests, e.g. metadata of a big corpus,
#'   can take several minutes on a slow connection.}
#' }
#' For example, to wait up to 30 minutes for a response, run
#' \code{options(rdracor.timeout = 1800)} before requesting data; to restore
#' the default, run \code{options(rdracor.timeout = NULL)}. To make the setting
#' permanent, add the \code{options()} call to your \code{.Rprofile}.
#'
#' @param request Character, valid GET request.
#' @param expected_type Character, 'MIME' type: one of
#' \code{"application/json"},  \code{"application/xml"}, \code{"text/csv"},
#' \code{"text/plain"}.
#' @param parse Logical, if \code{TRUE} (default value), then a response is
#'   parsed depending on \code{expected_type}. See details below.
#' @param default_type Logical, if \code{TRUE}, default response data type is
#'   returned. Therefore, a response is not parsed and \code{parse} is ignored.
#'   The default value is \code{FALSE}.
#' @param split_text Logical, if \code{TRUE}, plain text lines are read as
#'   different values in a vector instead of returning one character value.
#'   Default value is \code{TRUE}.
#' @param as_tibble Logical, if \code{TRUE}, data frame will be returned as a
#'   tidyverse tibble (\code{tbl_df}). The default value is \code{TRUE}.
#' @param ... Other arguments passed to a parser function.
#' @return A content of a response to GET method to the 'DraCor' API. If
#' \code{parse = FALSE} or \code{default_type = TRUE}, a single character value
#' is returned. Otherwise, the resulting value is parsed according to a value of
#' \code{default_type} parameter. The resulting structure of the output depends
#' on the selected \code{default_type} value, the respective function for
#' parsing (see \code{default_type}) and additional parameters that are passed
#' to the function for parsing. If 'DraCor' API is not available, \code{NULL}
#' is returned invisibly (see Details).
#' @examplesIf dracor_api_available()
#' dracor_api("https://dracor.org/api/v1/info", expected_type = "application/json")
#' @seealso \code{\link{dracor_sparql}} \code{\link{dracor_api_available}}
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
  resp <- tryCatch(
    httr::GET(
      request,
      if (!isTRUE(default_type)) httr::accept(expected_type),
      httr::timeout(getOption("rdracor.timeout", 600)),
      httr::config(
        connecttimeout = getOption("rdracor.connect_timeout", 30),
        ssl_verifypeer = FALSE
      )
    ),
    error = function(e) {
      hint <- if (grepl("timed out", conditionMessage(e), ignore.case = TRUE)) {
        sprintf(
          "\nTime limits can be increased, see ?dracor_api. Current values: options(rdracor.timeout = %s, rdracor.connect_timeout = %s)",
          getOption("rdracor.timeout", 600),
          getOption("rdracor.connect_timeout", 30)
        )
      } else {
        ""
      }
      message(
        "Could not connect to 'DraCor' API: ", conditionMessage(e), hint,
        "\nRequest: ", request
      )
      NULL
    }
  )
  if (is.null(resp)) {
    return(invisible(NULL))
  }
  if (httr::status_code(resp) != 200) {
    dracor_error(resp)
    return(invisible(NULL))
  }
  cont <- httr::content(resp, as = "text", encoding = "UTF-8")
  if (isTRUE(default_type) || !isTRUE(parse)) {
    return(cont)
  }
  tryCatch(
    switch(expected_type,
           "application/json" = if (as_tibble) {
             tibble::as_tibble(jsonlite::fromJSON(cont, ...))
           } else {
             jsonlite::fromJSON(cont, ...)
           },
           "application/xml" = xml2::read_xml(cont, ...),
           "text/csv" = if (as_tibble) {
             tibble::as_tibble(data.table::fread(cont, ...))
           } else {
             data.table::fread(cont, ...)
           },
           "text/plain" = if (split_text) {
             unlist(strsplit(cont, "\n"))
           } else {
             cont
           }
    ),
    error = function(e) {
      message(
        "'DraCor' API returned data that could not be parsed as ",
        expected_type, ": ", conditionMessage(e),
        "\nRequest: ", request
      )
      invisible(NULL)
    }
  )
}


#' Check whether 'DraCor' API is available
#'
#' \code{dracor_api_available()} sends a light request to 'DraCor' API and
#' checks whether it responds. It never throws an error, so it can be used to
#' run code that needs 'DraCor' API only if the API is available.
#'
#' @param dracor_api_url Character, 'DraCor' API URL. If NULL (default), the
#' current 'DraCor' API URL is used.
#' @param timeout Numeric, maximum number of seconds to wait for the response.
#' Default value is 10.
#' @return \code{TRUE} if 'DraCor' API is available, \code{FALSE} otherwise.
#' @examples
#' dracor_api_available()
#' @seealso \code{\link{dracor_api_info}}
#' @export
dracor_api_available <- function(dracor_api_url = NULL, timeout = 10) {
  if (is.null(dracor_api_url)) dracor_api_url <- get_dracor_api_url()
  resp <- tryCatch(
    httr::GET(
      paste0(dracor_api_url, "/info"),
      httr::timeout(timeout),
      httr::config(ssl_verifypeer = FALSE)
    ),
    error = function(e) NULL
  )
  !is.null(resp) && httr::status_code(resp) == 200
}

#' Submit SPARQL queries to DraCor API
#'
#' \code{dracor_sparql()} submits SPARQL queries and parses the result.
#'
#' @return SPARQL xml parsed.
#' @param sparql_query Character, SPARQL query.
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @inheritParams get_play_metadata
#' @examplesIf dracor_api_available()
#' dracor_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10")
#' # If you want to avoid parsing by xml2::read_xml():
#' dracor_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10", parse = FALSE)
#' @seealso \code{\link{get_dracor}}
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

#' Retrieve 'DraCor' API info
#'
#' \code{dracor_api_info()} returns information about 'DraCor' API: name of
#' the API, status, existdb version, API version etc.
#'
#' @param dracor_api_url Character, 'DraCor' API URL. If NULL (default), the
#' current 'DraCor' API URL is used.
#' @param new_dracor_api_url Character, 'DraCor' API URL that will replace
#' the current 'DraCor' API URL.
#'
#' @return NULL
#' @examplesIf dracor_api_available()
#' dracor_api_info()
#' get_dracor_api_url()
#' @seealso \code{\link{dracor_api}} \code{\link{dracor_api_available}}
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble
#' @export
dracor_api_info <- function(dracor_api_url = NULL) {
  if (is.null(dracor_api_url)) dracor_api_url <- get_dracor_api_url()
  api_info_list <- dracor_api(paste0(dracor_api_url, "/info"),
                              as_tibble = FALSE)
  if (is.null(api_info_list)) {
    cat("DraCor API was not found:", dracor_api_url, "\n")
    return(invisible(NULL))
  }
  cat("DraCor API URL: ", dracor_api_url, "\n",
      paste(names(api_info_list),
            unlist(api_info_list),
            sep = ": ",
            collapse = "\n"))
  invisible(NULL)
}

#' @export
#' @describeIn dracor_api_info Returns 'DraCor' API URL in use
get_dracor_api_url <- function() {
  the$dracor_api_url
}


#' @export
#' @describeIn dracor_api_info Set new 'DraCor' API URL (globally), returns NULL
set_dracor_api_url <- function(new_dracor_api_url) {
  cat("Working DraCor repository was changed from", get_dracor_api_url(), "\n")
  the$dracor_api_url <- new_dracor_api_url
  dracor_api_info()
}
