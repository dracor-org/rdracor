#' Retrieve metadata for a play
#'
#' The DraCor API lets you request metadata for a specific play, given corpus
#' and play names.
#'
#' @return List with a play metadata.
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_dracor}}). Character vector (longer than 1) is not supported.
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor_meta}}).
#' @param full_metadata Logical: if \code{TRUE} (default value), then additional metadata are retrieved.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_metadata(play = "gogol-zhenitba", corpus = "rus")
#' @seealso \code{\link{get_net_coocur_edges}}
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
    meta$cast <- get_play_cast(play = play, corpus = corpus)
    if (isTRUE(full_metadata)) {
      full_meta <-
        dracor_api(
          request = paste0("https://dracor.org/api/corpora/", corpus, "/metadata"),
          flatten = TRUE,
          as_tibble = FALSE
        )
      full_meta_play_list <- as.list(full_meta[full_meta$name == play,
                                               c(
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
                                               )])
      meta <- c(meta, full_meta_play_list)
    }
    purrr::modify_if(meta, is.data.frame, tibble::as_tibble)
  }


#' Retrieve an RDF for a play.
#'
#' The DraCor API lets you request a RDF (Resource Description Framework) data
#' for a play, given corpus and play names. RDF for plays can be useful for
#' extraction data for a play from \url{Wikidata.org}.
#'
#' @return RDF data parsed by {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @inheritParams get_play_metadata
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @examples
#' get_play_rdf(play = "gogol-zhenitba", corpus = "rus")
#' # If you want RDF without parsing by xml2::read_xml():
#' get_play_rdf(play = "gogol-zhenitba", corpus = "rus", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}}
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

#' Retrieve data for characters in a play.
#'
#' The DraCor API lets you request miscellaneous information for characters in
#' a play, given corpus and play names: name, number and size of their lines,
#' gender, some network metrics etc.
#'
#' @inheritParams get_play_metadata
#' @examples
#' get_play_cast(play = "gogol-zhenitba", corpus = "rus")
#' @seealso \code{\link{get_play_metadata}}
#' @export
get_play_cast <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "cast"),
    expected_type = "application/json",
    ...
  )
}
