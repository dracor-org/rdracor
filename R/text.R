#' Retrieve a text for a play in 'TEI'
#'
#' \code{get_text_tei()} requests a text for a play in 'TEI' format, given play
#' and corpus names. 'TEI' is an XML vocabulary, which makes it easy to extract
#' structural information \insertCite{fischer2019programmable}{rdracor}.
#'
#' @return TEI data parsed by
#'   {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @inheritParams get_play_characters
#' @examples
#' get_text_tei(play = "lessing-emilia-galotti", corpus = "ger")
#' # If you want a text in TEI without parsing by xml2::read_xml():
#' get_text_tei(play = "lessing-emilia-galotti", corpus = "ger", parse = FALSE)
#' @seealso \code{\link{get_text_df}} \code{\link{get_text_chr_spoken}}
#' \code{\link{tei_to_df}}
#' @references
#'   \insertAllCited{}
#' @importFrom xml2 read_xml
#' @export
get_text_tei <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "tei"),
    expected_type = "application/xml",
    ...
  )
}

#' Retrieve lines and stage directions for a play
#'
#' \code{get_text_chr_spoken()} request lines and stage directions for a play,
#' given play and corpus names.
#' @inheritParams get_play_characters
#' @param gender Character, optional parameter to extract lines for characters
#' of specified gender: \code{"MALE"}, \code{"FEMALE"}, \code{"UNKNOWN"}.
#' @param split_text If \code{TRUE} returns text as a character vector of lines.
#' Otherwise, returns text as one character value. \code{TRUE} by default.
#' @return For \code{get_text_chr_spoken()}, \code{get_text_chr_stage()} and
#' \code{get_text_chr_stage_with_sp()}: a character vector (if
#' \code{split_text = TRUE}, the default value) or a single character value (if
#' \code{split_text = FALSE)}.
#' For \code{get_text_chr_spoken_bych()}:
#' \describe{
#'   \item{\code{split_text = TRUE} and \code{as_data_frame = FALSE} (default)}{
#'   a named list with character vectors for every character}
#'   \item{\code{split_text = FALSE} and \code{as_data_frame = FALSE}}{a named
#' character vector (one value = one character)}
#'   \item{\code{split_text = TRUE} and \code{as_data_frame = TRUE}}{a data
#'   frame: every row represent a character, text of a play is stored in a
#'   \code{"text"} column, the \code{"text"} column is a list column with a
#'   character vector of lines}
#'   \item{\code{split_text = FALSE} and \code{as_data_frame = TRUE}}{a data
#'   frame: every row represent a character, text of a play is stored in a
#'   \code{"text"} column, the \code{"text"} column is a simple character
#'   column}
#' }
#' @examples
#' get_text_chr_spoken(play = "lessing-emilia-galotti", corpus = "ger")
#' get_text_chr_spoken(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger",
#'   gender = "FEMALE"
#' )
#' get_text_chr_spoken(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger",
#'   gender = "FEMALE",
#'   split_text = FALSE
#' )
#' get_text_chr_spoken_bych(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger"
#' )
#' get_text_chr_stage(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger"
#' )
#' get_text_chr_stage_with_sp(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger"
#' )
#' @seealso \code{\link{get_text_tei}} \code{\link{get_text_df}}
#' @export
get_text_chr_spoken <-
  function(play = NULL,
           corpus = NULL,
           gender = NULL,
           split_text = TRUE,
           ...) {
    request <- form_play_request(play = play,
                                 corpus = corpus,
                                 type = "spoken-text")
    if (!is.null(gender)) {
      if (!(toupper(gender) %in% c("MALE", "FEMALE", "UNKNOWN"))) {
        stop("gender must be one of 'MALE', 'FEMALE','UNKNOWN'")
      }
      request <- paste0(request, "?sex=", toupper(gender))
    }
    dracor_api(request,
      expected_type = "text/plain", split_text = split_text, ...
    )
  }

#' @param as_data_frame If \code{TRUE} returns data frame with a row for every
#' character and text in a column \code{"text"}. Otherwise, a named list with
#' character values is returned. \code{FALSE} by default.
#' @importFrom purrr map_chr
#' @export
#' @describeIn get_text_chr_spoken Retrieves lines grouped by characters in a
#' play, given play and corpus names.
get_text_chr_spoken_bych <-
  function(play = NULL,
           corpus = NULL,
           split_text = TRUE,
           as_data_frame = FALSE, ...) {
    play_text <- dracor_api(
      form_play_request(
        play = play,
        corpus = corpus,
        type = "spoken-text-by-character"
      ),
      expected_type = "application/json",
      ...
    )
    if (!isTRUE(split_text)) {
      play_text$text <- purrr::map_chr(play_text$text, paste0, collapse = "\n")
    }
    if (isTRUE(as_data_frame)) {
      return(play_text)
    } else {
      play_text_list <- play_text$text
      names(play_text_list) <- play_text$id
      return(play_text_list)
    }
  }

#' @export
#' @describeIn get_text_chr_spoken Retrieves all stage directions of a play,
#' given play and corpus names.
get_text_chr_stage <-
  function(play = NULL,
           corpus = NULL,
           split_text = TRUE,
           ...) {
    dracor_api(
      form_play_request(
        play = play,
        corpus = corpus,
        type = "stage-directions"
      ),
      expected_type = "text/plain",
      split_text = split_text,
      ...
    )
  }

#' @export
#' @describeIn get_text_chr_spoken Retrieves all stage directions of a play
#' including speakers (if applicable), given play and corpus names.
get_text_chr_stage_with_sp <-
  function(play = NULL,
           corpus = NULL,
           split_text = TRUE,
           ...) {
    dracor_api(
      form_play_request(
        play = play,
        corpus = corpus,
        type = "stage-directions-with-speakers"
      ),
      expected_type = "text/plain",
      split_text = split_text,
      ...
    )
  }
