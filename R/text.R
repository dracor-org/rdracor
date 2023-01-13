#' Retrieve a text for a play in TEI.
#'
#' The DraCor API lets you request a text for a play in TEI format, given corpus
#' and play names. TEI is an XML vocabulary, which makes it easy to extract
#' structural information.
#'
#' @return Text of a play parsed by
#'   {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @inheritParams get_play_metadata
#' @examples
#' get_text_tei(play = "gogol-zhenitba", corpus = "rus")
#' # If you want a text in TEI without parsing by xml2::read_xml():
#' get_text_tei(play = "gogol-zhenitba", corpus = "rus", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}}
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
#' The DraCor API lets you request lines and stage directions for a play, given
#' corpus and play names.
#'
#' @inheritParams get_play_metadata
#' @param gender Character, optional parameter to extract lines for characters
#' of specified gender: \code{"MALE"}, \code{"FEMALE"}, \code{"UNKNOWN"}.
#' @param split_text If \code{TRUE} returns text as a character vector of lines.
#' Otherwise, returns text as one character value. \code{TRUE} by default.
#' @examples
#' get_text_chr_spoken(play = "gogol-zhenitba", corpus = "rus")
#' get_text_chr_spoken(play = "gogol-zhenitba", corpus = "rus", "FEMALE")
#' get_text_chr_spoken(play = "gogol-zhenitba", corpus = "rus", "FEMALE", split = FALSE)
#' get_text_chr_spoken_bych(play = "gogol-zhenitba", corpus = "rus")
#' get_text_chr_stage(play = "gogol-zhenitba", corpus = "rus")
#' get_text_chr_stage_with_sp(play = "gogol-zhenitba", corpus = "rus")
#' @seealso \code{\link{get_play_metadata}}
#' @export
get_text_chr_spoken <-
  function(play = NULL,
           corpus = NULL,
           gender = NULL,
           split_text = TRUE,
           ...) {
    request <- form_play_request(play = play, corpus = corpus, type = "spoken-text")
    if (!is.null(gender)) {
      if (!(toupper(gender) %in% c("MALE", "FEMALE", "UNKNOWN"))) {
        stop("gender must be one of 'MALE', 'FEMALE','UNKNOWN'")
      }
      request <- paste0(request, "?gender=", toupper(gender))
    }
    dracor_api(request,
      expected_type = "text/plain", ...
    )
  }

#' @param dataframe If \code{TRUE} returns data frame with a row for every
#' character and text in a column \code{"text"}. \code{FALSE} by default.
#' @importFrom purrr map_chr
#' @export
#' @describeIn get_text_chr_spoken Retrieve lines grouped by characters in a
#' play, given corpus and play names.
get_text_chr_spoken_bych <-
  function(play = NULL, corpus = NULL, split_text = TRUE, dataframe = FALSE, ...) {
    play_text <- dracor_api(
      form_play_request(play = play, corpus = corpus, type = "spoken-text-by-character"),
      expected_type = "application/json",
      ...
    )
    if (!split_text) {
      play_text$text <- purrr::map_chr(play_text$text, paste0, collapse = "\n")
    }
    if (dataframe) {
      return(play_text)
    } else {
      play_text_list <- play_text$text
      names(play_text_list) <- play_text$id
      return(play_text_list)
    }
  }

#' @export
#' @describeIn get_text_chr_spoken Retrieve all stage directions of a play,
#' given corpus and play names.
get_text_chr_stage <-
  function(play = NULL, corpus = NULL, split_text = TRUE, ...) {
    dracor_api(form_play_request(play = play, corpus = corpus, type = "stage-directions"),
      expected_type = "text/plain",
      ...
    )
  }

#' @export
#' @describeIn get_text_chr_spoken Retrieve all stage directions of a play
#' including speakers (if applicable), given corpus and play names.
get_text_chr_stage_with_sp <-
  function(play = NULL, corpus = NULL, split_text = TRUE, ...) {
    dracor_api(
      form_play_request(play = play, corpus = corpus, type = "stage-directions-with-speakers"),
      expected_type = "text/plain",
      ...
    )
  }
