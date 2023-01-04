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
#' @param ... Additional arguments passed to \code{\link{dracor_api}}.
#' @examples
#' get_play_metadata(play = "gogol-zhenitba", corpus = "rus")
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
get_play_metadata <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus),
    expected_type = "application/json", as_tibble = FALSE, ...
  )
}

#' Retrieve network metrics for a play
#'
#' The DraCor API lets you request network metrics for a specific play, given
#' corpus and play names. Play network is constructed based on characters'
#' cooccurrence matrix.
#'
#' @return List with network metrics for a specific play.
#' @inheritParams get_play_metadata
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
get_play_metrics <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "metrics"),
    expected_type = "application/json",
    as_tibble = FALSE,
    ...
  )
}

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
#' get_play_tei(play = "gogol-zhenitba", corpus = "rus")
#' # If you want a text in TEI without parsing by xml2::read_xml():
#' get_play_tei(play = "gogol-zhenitba", corpus = "rus", parse = FALSE)
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
get_play_tei <- function(play = NULL, corpus = NULL,  ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "tei"),
    expected_type = "application/xml",
    ...
  )
}

#' Retrieve an RDF for a play.
#'
#' The DraCor API lets you request a RDF (Resource Description Framework) data
#' for a play, given corpus and play names. RDF for plays can be useful for
#' extraction data for a play from \url{Wikidata.org}.
#'
#' @return RDF data parsed by {\code{\link[xml2:read_xml]{xml2::read_xml()}}}.
#' @inheritParams get_play_metadata
#' @examples
#' get_play_rdf(play = "gogol-zhenitba", corpus = "rus")
#' # If you want RDF without parsing by xml2::read_xml():
#' get_play_rdf(play = "gogol-zhenitba", corpus = "rus", parse = FALSE)
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
get_play_rdf <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "rdf"),
    expected_type = "application/xml",
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
get_play_cast <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "cast"),
    expected_type = "application/json",
    ...
  )
}

#' Retrieve edges list for a play.
#'
#' The DraCor API lets you request edges list for a play network, given corpus
#' and play names. Each row represents cooccurrences of two characters in a play
#'  - number of scenes where two characters appeared together. This edges list
#' can be used to construct a network for a play.
#'
#' @inheritParams get_play_metadata
#' @examples
#' get_play_networkdata_csv(play = "gogol-zhenitba", corpus = "rus")
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
  function(play = NULL, corpus = NULL, ...) {
    dracor_api(
      form_play_request(play = play, corpus = corpus, type = "networkdata/csv"),
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
#' @inheritParams get_play_metadata
#' @examples
#' get_play_networkdata_gexf(play = "gogol-zhenitba", corpus = "rus")
#' # If you want GEXF without parsing by xml2::read_xml():
#' get_play_networkdata_gexf(play = "gogol-zhenitba", corpus = "rus", parse = FALSE)
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
  function(play = NULL, corpus = NULL, ...) {
    dracor_api(form_play_request(play = play, corpus = corpus, type = "networkdata/gexf"),
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
#' get_play_spoken_text(play = "gogol-zhenitba", corpus = "rus")
#' get_play_spoken_text(play = "gogol-zhenitba", corpus = "rus", "FEMALE")
#' get_play_spoken_text(play = "gogol-zhenitba", corpus = "rus", "FEMALE", split = FALSE)
#' get_play_spoken_text_bych(play = "gogol-zhenitba", corpus = "rus")
#' get_play_stage_directions(play = "gogol-zhenitba", corpus = "rus")
#' get_play_stage_directions_with_sp(play = "gogol-zhenitba", corpus = "rus")
#' @seealso \code{\link{get_play_metadata}}, \code{\link{get_play_metrics}},
#'   \code{\link{get_play_tei}}, \code{\link{get_play_rdf}},
#'   \code{\link{get_play_cast}},
#'   \code{\link{get_play_networkdata_csv}},
#'   \code{\link{play_igraph}}
#' @export
get_play_spoken_text <-
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

#' @export
#' @describeIn get_play_spoken_text Retrieve lines grouped by characters in a
#' play, given corpus and play names.
get_play_spoken_text_bych <-
  function(play = NULL, corpus = NULL, split_text = TRUE, ...) {
    dracor_api(
      form_play_request(play = play, corpus = corpus, type = "spoken-text-by-character"),
      expected_type = "application/json",
      ...
    )
  }

#' @export
#' @describeIn get_play_spoken_text Retrieve all stage directions of a play,
#' given corpus and play names.
get_play_stage_directions <-
  function(play = NULL, corpus = NULL, split_text = TRUE, ...) {
    dracor_api(form_play_request(play = play, corpus = corpus, type = "stage-directions"),
      expected_type = "text/plain",
      ...
    )
  }

#' @export
#' @describeIn get_play_spoken_text Retrieve all stage directions of a play
#' including speakers (if applicable), given corpus and play names.
get_play_stage_directions_with_sp <-
  function(play = NULL, corpus = NULL, split_text = TRUE, ...) {
    dracor_api(
      form_play_request(play = play, corpus = corpus, type = "stage-directions-with-speakers"),
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
#' @inheritParams get_play_metadata
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
  query <- paste0(
    "https://dracor.org/fuseki/sparql?query=",
    URLencode(sparql_query, reserved = TRUE)
  )
  dracor_api(query, expected_type = "application/xml", ...)
}

#' Retrieve an igraph network for a play.
#'
#' Returns a play nertwork, given corpus and play names. Play network is
#' constructed based on characters' cooccurrence matrix.
#'
#' @return \code{play_igraph} Object that inherits \code{igraph} and can be
#' treated as such.
#' @inheritParams get_play_metadata
#' @examples
#' library(igraph)
#' zhenitba_igraph <- play_igraph(play = "gogol-zhenitba", corpus = "rus")
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
#'   \code{\link{is.play_igraph}}
#' @import igraph
#' @import data.table
#' @export
play_igraph <- function(play = NULL, corpus = NULL) {
  nodes <- get_play_cast(play = play, corpus = corpus)
  nodes <- nodes[, c("id", names(nodes)[names(nodes) != "id"])]
  edges <- get_play_networkdata_csv(play = play, corpus = corpus)
  data.table::setnames(edges, tolower(names(edges)))
  edges <- edges[, c("source", "target", "weight")]
  graph <-
    igraph::graph_from_data_frame(edges, directed = FALSE, vertices = nodes)
  structure(graph,
    play = play,
    corpus = corpus,
    class = c("play_igraph", "igraph")
  )
}

#' Test an object to be a 'play_igraph' object.
#'
#' Test that object is a \code{play_igraph}.
#'
#' @param x An R object.
#' @export
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
#' zhenitba_igraph <- play_igraph(play = "gogol-zhenitba", corpus = "rus")
#' label_play_igraph(zhenitba_igraph, max_graph_size = 10, top_nodes = 4)
#' @seealso \code{\link{play_igraph}}
#' @import igraph
#' @export
label_play_igraph <- function(graph,
                              max_graph_size = 30L,
                              top_nodes = 3L) {
  vertices_labels <- igraph::V(graph)$name
  if (igraph::vcount(graph) > max_graph_size) {
    vertices_labels[igraph::vcount(graph) - rank(igraph::V(graph)$numOfWords,
                                                         ties.method = "max") >= top_nodes] <-
      NA
  }
  vertices_labels
}

#' @param x A \code{play_igraph} object to plot.
#' @method plot play_igraph
#' @export
#' @describeIn play_igraph Plot \code{play_igraph} using \code{play_igraph}
#' with slightly modified defaults.
plot.play_igraph <- function(x,
                             ...) {
  gender_colours <- c(
    MALE = "#26B69E",
    FEMALE = "#9400E9",
    UNKNOWN = "#6F747E"
  )
  vertex.label <- label_play_igraph(x)
  vertex.label.color <- "black"
  vertex.label.family <- "sans"
  vertex.color <- gender_colours[igraph::V(x)$gender]
  vertex.size <- log(igraph::V(x)$numOfWords, base = 1.4)
  vertex.shape <- c("circle", "square")[as.numeric(igraph::V(x)$isGroup) + 1]
  vertex.frame.color <- "white"
  edge.width <- ((igraph::E(x)$weight) / max(igraph::E(x)$weight) *
    3)
  layout <- igraph::layout_with_kk(x)
  igraph::plot.igraph(
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


#' @param object An object of class \code{"play_igraph"}.
#' @method summary play_igraph
#' @export
#' @describeIn play_igraph Meaningful summary for \code{"play_igraph"} object:
#'   network properties, gender distribution
summary.play_igraph <- function(object, ...) {
  genders <- igraph::V(object)$gender
  density <- igraph::edge_density(object)
  diam <- igraph::diameter(object, directed = FALSE)
  mean_dist <- igraph::mean_distance(object, directed = FALSE)
  cohesion <- igraph::graph.cohesion(object)
  assort <- igraph::assortativity.degree(object, directed = FALSE)
  global_clustering <- igraph::transitivity(object, "global")
  local_clustering_average <-
    igraph::transitivity(object, "average")
  degrees <- igraph::degree(object)
  top_nodes <-
    paste(names(degrees)[degrees == max(degrees)], collapse = ", ")
  cat(
    sprintf(
      "%s: %s - network summary",
      attr(object, "corpus"),
      attr(object, "play")
    ),
    sprintf(""),
    sprintf(
      "         Size: %i (%i FEMALES, %i MALES, %i UNKNOWN)",
      length(genders),
      sum(genders == "FEMALE"),
      sum(genders == "MALE"),
      sum(genders == "UNKNOWN")
    ),
    sprintf("      Density: %.2f", density),
    sprintf("       Degree:"),
    sprintf("         - Maximum: %i (%s)", max(degrees), top_nodes),
    sprintf("     Distance:"),
    sprintf("         - Maximum (Diameter): %i", diam),
    sprintf("         - Average: %.2f", mean_dist),
    sprintf("   Clustering:"),
    sprintf("         - Global: %.2f", global_clustering),
    sprintf("         - Average local: %.2f", local_clustering_average),
    sprintf("     Cohesion: %i", cohesion),
    sprintf("Assortativity: %.2f", assort),
    sep = "\t\n"
  )
}
