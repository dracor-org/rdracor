#' Retrieve data for characters in a play
#'
#' \code{get_play_characters()} requests miscellaneous information for characters in
#' a play, given play and corpus names: name, number and size of their lines,
#' gender, some network metrics etc.
#'
#' @return Data frame, every raw represents one character in the play.
#'
#' @param play Character, name of a play (you can find all play names in
#'   \code{"playName"} column within an object returned by
#'   \code{\link{get_dracor}}). Character vector (longer than 1) is not
#'   supported.
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by
#'   \code{\link{get_dracor_meta}}).
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examplesIf dracor_api_available()
#' get_play_characters(play = "lessing-emilia-galotti", corpus = "ger")
#' @seealso \code{\link{get_play_metadata}}
#' @export
get_play_characters <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "characters"),
    expected_type = "application/json",
    ...
  )
}

#' Retrieve metadata for a play
#'
#' \code{get_play_metadata()} requests metadata for a specific play, given play
#' and corpus names.
#'
#' @return List with the play metadata.
#' @inheritParams get_play_characters
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional
#' metadata are retrieved.
#' @examplesIf dracor_api_available()
#' get_play_metadata(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger",
#'   full_metadata = FALSE
#' )
#' @seealso \code{\link{get_net_cooccur_edges}} \code{\link{get_play_rdf}}
#' \code{\link{get_play_characters}}
#' @importFrom purrr modify_at
#' @importFrom tibble as_tibble
#' @export
get_play_metadata <-
  function(play = NULL,
           corpus = NULL,
           full_metadata = TRUE,
           ...) {
    meta <- dracor_api(
      form_play_request(play = play, corpus = corpus),
      expected_type = "application/json",
      as_tibble = FALSE,
      ...
    )
    if (is.null(meta)) {
      return(invisible(NULL))
    }
    characters <- get_play_characters(play = play, corpus = corpus)
    if (is.null(characters)) {
      return(invisible(NULL))
    }
    meta$characters <- characters
    if (isTRUE(full_metadata)) {
      full_meta <-
        dracor_api(
          request = paste0(
            get_dracor_api_url(),
            "/corpora/",
            corpus,
            "/metadata"
          ),
          flatten = TRUE,
          as_tibble = FALSE
        )
      if (is.null(full_meta)) {
        return(invisible(NULL))
      }
      extra_columns <- c(
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
      # keep only the columns that the API still returns and that are not
      # already in the play metadata
      extra_columns <- setdiff(
        intersect(extra_columns, names(full_meta)),
        names(meta)
      )
      full_meta_play_list <- as.list(full_meta[
        full_meta$name == play,
        extra_columns,
        drop = FALSE
      ])
      meta <- c(meta, full_meta_play_list)
    }
    purrr::modify_if(meta, is.data.frame, tibble::as_tibble)
  }


#' Retrieve an RDF for a play
#'
#' \code{get_play_rdf()} requests an RDF (Resource Description Framework) data
#' for a play, given play and corpus names. RDF for plays can be useful for
#' extraction data for a play from
#' \url{https://www.wikidata.org/wiki/Wikidata:Main_Page}.
#'
#' @return RDF data parsed by {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @inheritParams get_play_characters
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @examplesIf dracor_api_available()
#' get_play_rdf(play = "lessing-emilia-galotti", corpus = "ger")
#' # If you want RDF without parsing by xml2::read_xml():
#' get_play_rdf(play = "lessing-emilia-galotti", corpus = "ger", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}} \code{\link{get_play_characters}}
#' @export
get_play_rdf <-
  function(play = NULL,
           corpus = NULL,
           parse = TRUE,
           ...) {
    dracor_api(
      form_play_request(
        play = play,
        corpus = corpus,
        type = "rdf"
      ),
      expected_type = "application/xml",
      parse = parse,
      ...
    )
  }
