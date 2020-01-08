#' Retrieve metadata for a play.
#'
#' The DraCor API lets you request metadata for a specific play, given corpus
#' and play names.
#'
#' @return List with a play metadata
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_metadata(corpus = "rus", play = "gogol-zhenitba")
#' @seealso \code{\link{get_play_metrics}}, \code{\link{get_play_tei}},
#'   \code{\link{get_play_rdf}}, \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{get_play_networkdata_gexf}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#'   \code{\link{play_igraph}}
#'
#' @export
get_play_metadata <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play),
             expected_type = "application/json", ...)
}

#' Retrieve network metrics for a play.
#'
#' The DraCor API lets you request network metrics for a specific play, given
#' corpus and play names. Play network is constructed based on characters'
#' cooccurrence matrix.
#'
#' @return List with network metrics for a specific play.
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_metrics(corpus = "rus", play = "gogol-zhenitba")
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_tei}},
#'   \code{\link{get_play_rdf}}, \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{get_play_networkdata_gexf}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#'   \code{\link{play_igraph}}
#' @export
get_play_metrics <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "metrics"),
             expected_type = "application/json",
             ...)
}

#' Retrieve a text for a play in TEI.
#'
#' The DraCor API lets you request a text for a play in TEI format, given corpus
#' and play names. TEI is an XML vocabulary, which makes it easy to extract
#' structural information.
#'
#' @return Text of a play parsed by
#'   {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_tei(corpus = "rus", play = "gogol-zhenitba")
#' # If you want a text in TEI without parsing by xml2::read_xml():
#' get_play_tei(corpus = "rus", play = "gogol-zhenitba", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_rdf}}, \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{get_play_networkdata_gexf}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#'   \code{\link{play_igraph}}
#' @importFrom xml2 read_xml
#' @export
get_play_tei <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "tei"),
             expected_type = "application/xml",
             ...)
}

#' Retrieve an RDF for a play.
#'
#' The DraCor API lets you request a RDF (Resource Description Framework) data
#' for a play, given corpus and play names. RDF for plays can be useful for
#' extraction data for a play from \url{Wikidata.org}.
#'
#' @return RDF data parsed by {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_rdf(corpus = "rus", play = "gogol-zhenitba")
#' # If you want RDF without parsing by xml2::read_xml():
#' get_play_rdf(corpus = "rus", play = "gogol-zhenitba", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_tei}}, \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{get_play_networkdata_gexf}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#'   \code{\link{play_igraph}}
#' @export
get_play_rdf <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "rdf"),
             expected_type = "application/xml",
             ...)
}

#' Retrieve data for characters in a play.
#'
#' The DraCor API lets you request miscellaneous information for characters in
#' a play, given corpus and play names: name, number and size of their lines,
#' gender, some network metrics etc.
#'
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_cast(corpus = "rus", play = "gogol-zhenitba")
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_tei}}, \code{\link{get_play_rdf}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{get_play_networkdata_gexf}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#'   \code{\link{play_igraph}}
#' @export
get_play_cast <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "cast"),
             expected_type = "application/json",
             ...)
}

#' Retrieve edges list for a play.
#'
#' The DraCor API lets you request edges list for a play network, given corpus
#' and play names. Each row represents cooccurrences of two characters in a play
#'  - number of scenes where two characters appeared together. This edges list
#' can be used to construct a network for a play.
#'
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_networkdata_csv(corpus = "rus", play = "gogol-zhenitba")
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_tei}}, \code{\link{get_play_rdf}},
#'   \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_gexf}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#'   \code{\link{play_igraph}}
#' @export
get_play_networkdata_csv <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(
      form_play_request(corpus, play, type = "networkdata/csv"),
      expected_type = "text/csv",
      data.table = FALSE,
      encoding = "UTF-8",
      ...
    )
  }

#' Retrieve network for a play in GEXF.
#'
#' The DraCor API lets you request a play network in GEXF (Graph Exchange XML
#' Format), given corpus and play names. GEXF is a format used in Gephi - an
#' open source software for network analysis and visualization.
#'
#' @return GEXF data parsed by {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_networkdata_gexf(corpus = "rus", play = "gogol-zhenitba")
#' # If you want GEXF without parsing by xml2::read_xml():
#' get_play_networkdata_gexf(corpus = "rus", play = "gogol-zhenitba", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_tei}}, \code{\link{get_play_rdf}},
#'   \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#'   \code{\link{play_igraph}}
#' @export
get_play_networkdata_gexf <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(form_play_request(corpus, play, type = "networkdata/gexf"),
               expected_type = "application/xml",
               ...)
  }

#' Retrieve lines and stage directions for a play
#'
#' The DraCor API lets you request lines and stage directions for a play, given
#' corpus and play names.
#'
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param gender Character, optional parameter to extract lines for characters
#' of specified gender: \code{"MALE"}, \code{"FEMALE"}, \code{"UNKNOWN"}.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_spoken_text("rus", "gogol-zhenitba")
#' get_play_spoken_text("rus", "gogol-zhenitba", "FEMALE")
#' get_play_spoken_text_bych("rus", "gogol-zhenitba")
#' get_play_stage_directions("rus", "gogol-zhenitba")
#' get_play_stage_directions_with_sp("rus", "gogol-zhenitba")
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_tei}}, \code{\link{get_play_rdf}},
#'   \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{play_igraph}}
#' @export
get_play_spoken_text <-
  function(corpus = NULL,
           play = NULL,
           gender = NULL,
           ...) {
    request <- form_play_request(corpus, play, type = "spoken-text")
    if (!is.null(gender)) {
      if (!(toupper(gender) %in% c("MALE", "FEMALE", "UNKNOWN"))) {
        stop("gender must be one of 'MALE', 'FEMALE','UNKNOWN'")
      }
      request <- paste0(request, "?gender=", toupper(gender))
    }
    dracor_api(request,
               expected_type = "text/plain", ...)
  }

#' @export
#' @describeIn get_play_spoken_text Retrieve lines grouped by characters in a
#' play, given corpus and play names.
get_play_spoken_text_bych <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(
      form_play_request(corpus, play, type = "spoken-text-by-character"),
      expected_type = "application/json",
      ...
    )
  }

#' @export
#' @describeIn get_play_spoken_text Retrieve all stage directions of a play,
#' given corpus and play names.
get_play_stage_directions <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(form_play_request(corpus, play, type = "stage-directions"),
               expected_type = "text/plain",
               ...)
  }

#' @export
#' @describeIn get_play_spoken_text Retrieve all stage directions of a play
#' including speakers (if applicable), given corpus and play names.
get_play_stage_directions_with_sp <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(
      form_play_request(corpus, play, type = "stage-directions-with-speakers"),
      expected_type = "text/plain",
      ...
    )
  }

#' Submit SPARQL queries to DraCor API.
#'
#' The DraCor API lets you submit SPARQL queries.
#'
#' @return SPARQL xml parsed by {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @param sparql_query Character, SPARQL query.
#' of specified gender: \code{"MALE"}, \code{"FEMALE"}, \code{"UNKNOWN"}.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10")
#' # If you want to avoid parsing by xml2::read_xml():
#' get_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10", parse = FALSE)
#' @importFrom utils URLencode
#' @export
get_sparql <- function(sparql_query = NULL, ...) {
  if (is.null(sparql_query)) {
    stop("SPARQL query must be provided")
  }
  query <- paste0("https://dracor.org/api/sparql?query=",
                  URLencode(sparql_query, reserved = TRUE))
  dracor_api(query, expected_type = "application/xml", ...)
}

#' Retrieve an igraph network for a play.
#'
#' Returns a play nertwork, given corpus and play names. Play network is
#' constructed based on characters' cooccurrence matrix.
#'
#' @return \code{play_igraph} Object that inherits \code{igraph} and can be
#' treated as such.
#' @param corpus Character, name of the corpus (you can find all corpus names in
#'   \code{name} column within an object returned by \code{\link{get_dracor}}).
#' @param play Character, name of the play (you can find all play names in
#'   \code{playName} column within an object returned by
#'   \code{\link{get_corpus}}). Character vector is not supported.
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' library(igraph)
#' zhenitba_igraph <- play_igraph("rus", "gogol-zhenitba")
#' igraph::diameter(zhenitba_igraph)
#' plot(zhenitba_igraph)
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_tei}}, \code{\link{get_play_rdf}},
#'   \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{get_play_networkdata_gexf}},
#'   \code{\link{get_play_spoken_text}},
#'   \code{\link{get_play_spoken_text_bych}},
#'   \code{\link{get_play_stage_directions}},
#'   \code{\link{get_play_stage_directions_with_sp}},
#' @import igraph
#' @exportClass play_igraph
#' @export
play_igraph <- function(corpus = NULL, play = NULL) {
  nodes <- fromJSON(form_play_request(corpus, play, "cast"))
  nodes <- nodes[, c("id", names(nodes)[names(nodes) != "id"])]
  edges <- fread(form_play_request(corpus, play, "networkdata/csv"),
                 encoding = "UTF-8")
  setnames(edges, tolower(names(edges)))
  edges <- edges[, c("source", "target", "weight")]
  graph <-
    graph_from_data_frame(edges, directed = FALSE, vertices = nodes)
  structure(graph,
            class = c("play_igraph", "igraph"))
}

#' @method is play_igraph
#' @export
#' @describeIn play_igraph Tests that object is \code{play_igraph}.
is.play_igraph <- function(x) {
  inherits(x, "play_igraph")
}

#' Extract labels for plotting 'play_igraph' object.
#'
#' Extract labels for plotting 'play_igraph' object. \code{label_play_igraph}
#' gives control of overplotting for labels (i.e. character names) by deleting
#' extra labels if there are too many of them. This function can be used to set
#' \code{vertex.label} parameter for \code{\link{plot.play_igraph}}.
#'
#' \code{label_play_igraph} takes labels from a vertices data.frame column
#' \code{"name"}, checks that network size is more than \code{max_graph_size},
#' if it is true, returns names for top \code{top_nodes} and NA for the rest.
#'
#' @return Character vector of character names.
#' @param graph \code{play_igraph} object to plot.
#' @param max_graph_size Integer, maximum network size for plotting all labels
#' @param top_nodes Integer, number of labels to be plotted. Characters with the
#'   highest number of words will be selected.
#' @examples
#' library(igraph)
#' zhenitba_igraph <- play_igraph("rus", "gogol-zhenitba")
#' label_play_igraph(zhenitba_igraph, max_graph_size = 10, top_nodes = 4)
#' @seealso \code{\link{play_igraph}}
#' @import igraph
#' @export
label_play_igraph <- function(graph,
                             max_graph_size = 30L,
                             top_nodes = 3L) {
  vertices_labels <- V(graph)$name
  if (vcount(graph) > max_graph_size) {
    vertices_labels[vcount(graph) - rank(V(graph)$numOfWords, ties.method = "max") >= top_nodes] <-
      NA
  }
  vertices_labels
}

#' @method plot play_igraph
#' @export
#' @describeIn play_igraph Plot \code{play_igraph} using \code{play_igraph}
#' with slightly modified defaults.
plot.play_igraph <- function(x,
                             gender_colours = c(MALE = "#26B69E",
                                                FEMALE = "#9400E9",
                                                UNKNOWN = "#6F747E"),
                             vertex.label = label_play_igraph(x),
                             vertex.label.color = "black",
                             vertex.label.family = "sans",
                             vertex.color = gender_colours[V(x)$gender],
                             vertex.size = log(V(x)$numOfWords, base = 1.4),
                             vertex.shape = c("circle", "square")[as.numeric(V(x)$isGroup) +
                                                                    1],
                             vertex.frame.color = "white",
                             edge.width = ((E(x)$weight) / max(E(x)$weight) *
                                             3),
                             layout = layout_with_kk(x),
                             ...) {
  plot.igraph(
    x,
    gender_colours = gender_colours,
    vertex.label = vertex.label,
    vertex.label.color = vertex.label.color,
    vertex.label.family = vertex.label.family,
    vertex.color = vertex.color,
    vertex.size = vertex.size,
    vertex.shape = vertex.shape,
    vertex.frame.color = vertex.frame.color,
    edge.width = edge.width,
    layout = layout,
    ...
  )
}
