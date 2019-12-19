form_play_request <-
  function(corpus = NULL,
           play = NULL,
           type = NULL) {
    if (is.null(corpus)) {
      stop("You need to provide a corpus")
    }
    if (is.null(play)) {
      stop("You need to provide a play")
    }
    request <-
      paste0("https://dracor.org/api/corpora/", corpus , "/play/", play)
    if (!is.null(type)) {
      return(paste(request, type, sep = "/"))
    } else {
      return(request)
    }
  }


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
  } else if (floor(resp$status_code / 100) == 5) {
    stop(sprintf(
      "Status code - %i: Internal Dracor server problem",
      resp$status_code
    ))
  } else if (resp$status_code != 200) {
    stop(sprintf("Status code - %i: Unknown problem", resp$status_code))
  }
}

#' @import httr
#' @importFrom jsonlite fromJSON
#' @import xml2
#' @import data.table
#' @export
dracor_api <- function(request,
                       expected_format =
                         c("application/json",
                           "application/xml",
                           "text/csv",
                           "text/plain"),
                       default_format = FALSE,
                       split_text = TRUE,
                       ...) {
  expected_format <- match.arg(expected_format)
  if (default_format) {
    resp <- GET(request)
    return(content(resp, as = "text", encoding = "UTF-8"))
  } else {
    resp <- GET(request, accept(expected_format))
  }
  dracor_error(resp)
  cont <- content(resp, as = "text", encoding = "UTF-8")
  if (expected_format == "application/json") {
    return(fromJSON(cont, ...))
  } else if (expected_format == "application/xml") {
    return(read_xml(cont, ...))
  } else if (expected_format == "text/csv") {
    return(fread(cont, ...))
  } else if (expected_format == "text/plain") {
    if (split_text) {
      return(unlist(strsplit(cont, "\n")))
    } else {
      return(cont)
    }
  }
}

