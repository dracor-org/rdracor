#' Retrieve co-occurrence network metrics for a play
#'
#' The DraCor API lets you request network metrics for a specific play, given
#' corpus and play names. Play network is constructed based on characters'
#' cooccurrence matrix.
#'
#' @return List with network metrics for a specific play.
#' @inheritParams get_play_metadata
#' @examples
#' get_net_coocur_metrics(corpus = "rus", play = "gogol-zhenitba")
#' @seealso \code{\link{get_play_metadata}}
#' @export
get_net_coocur_metrics <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "metrics"),
             expected_type = "application/json",
             as_tibble = FALSE,
             ...
  )
}

#' Retrieve co-occurrence edges list for a play as a data frame.
#'
#' The DraCor API lets you request edges list for a play network, given corpus
#' and play names. Each row represents co-occurrences of two characters in a play
#'  - number of scenes where two characters appeared together. This edges list
#' can be used to construct a network for a play.
#'
#' @return data frame with edges (each row = one edge of a network).
#' @inheritParams get_play_metadata
#' @examples
#' get_net_coocur_edges(play = "gogol-zhenitba", corpus = "rus")
#' @seealso \code{\link{get_play_metadata}}
#' @export
get_net_coocur_edges <-
  function(play = NULL, corpus = NULL, ...) {
    dracor_api(
      form_play_request(play = play, corpus = corpus, type = "networkdata/csv"),
      expected_type = "text/csv",
      data.table = FALSE,
      encoding = "UTF-8",
      ...
    )
  }

#' Retrieve co-occurrence network for a play in GEXF.
#'
#' The DraCor API lets you request a play co-occurrence network in GEXF (Graph Exchange XML
#' Format), given corpus and play names. GEXF is a format used in Gephi - an
#' open source software for network analysis and visualization.
#'
#' @return GEXF data.
#' @inheritParams get_play_metadata
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @examples
#' get_net_coocur_gexf(play = "gogol-zhenitba", corpus = "rus")
#' # If you want GEXF without parsing by xml2::read_xml():
#' get_net_coocur_gexf(play = "gogol-zhenitba", corpus = "rus", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}}
#' @export
get_net_coocur_gexf <-
  function(play = NULL, corpus = NULL, parse = TRUE, ...) {
    dracor_api(form_play_request(play = play, corpus = corpus, type = "networkdata/gexf"),
      expected_type = "application/xml",
      parse = parse,
      ...
    )
  }

#' Retrieve co-occurrence network for a play in GraphML.
#'
#' The DraCor API lets you request a play co-occurrence network in GraphML,
#' given corpus and play names. GraphML is a common format for graphs based on
#' XML.
#'
#' @return graphml data.
#' @inheritParams get_play_metadata
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @examples
#' get_net_coocur_graphml(play = "gogol-zhenitba", corpus = "rus")
#' # If you want GEXF without parsing by xml2::read_xml():
#' get_net_coocur_graphml(play = "gogol-zhenitba", corpus = "rus", parse = FALSE)
#' @seealso \code{\link{get_play_metadata}}
#' @export
get_net_coocur_graphml <-
  function(play = NULL, corpus = NULL, parse = TRUE, ...) {
    dracor_api(form_play_request(play = play, corpus = corpus, type = "networkdata/graphml"),
               expected_type = "application/xml",
               parse = parse,
               ...
    )
  }

#' @export
#' @describeIn get_net_coocur_edges Retrieve kinship and other relationship
#' data, following the encoding scheme proposed in
#' \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
get_net_relations_edges <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "relations/csv"),
             expected_type = "text/csv",
             ...)
}

#' @export
#' @describeIn get_net_coocur_gexf Retrieve kinship and other relationship
#' data, following the encoding scheme proposed in
#' \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
get_net_relations_gexf <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "relations/gexf"),
             expected_type = "application/xml",
             ...)
}

#' @export
#' @describeIn get_net_coocur_graphml Retrieve kinship and other relationship
#' data, following the encoding scheme proposed in
#' \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
get_net_relations_graphml <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "relations/graphml"),
             expected_type = "application/xml",
             ...)
}

#' Retrieve an igraph co-occurrence network for a play.
#'
#' Returns a play network, given corpus and play names. Play network is
#' constructed based on characters' co-occurrence matrix.
#'
#' @return \code{coocur_igraph} Object that inherits \code{igraph} and can be
#' treated as such.
#' @inheritParams get_play_metadata
#' @examples
#' zhenitba_igraph <- get_coocur_igraph(play = "gogol-zhenitba", corpus = "rus")
#' igraph::diameter(zhenitba_igraph)
#' plot(zhenitba_igraph)
#' @seealso \code{\link{get_play_metadata}}
#' @import igraph
#' @import data.table
#' @export
get_coocur_igraph <- function(play = NULL, corpus = NULL) {
  nodes <- get_play_cast(play = play, corpus = corpus, as_tibble = FALSE)
  edges <- get_net_coocur_edges(play = play, corpus = corpus, as_tibble = FALSE)
  data.table::setnames(edges, tolower(names(edges)))
  edges <- edges[, c("source", "target", "weight")]
  graph <-
    igraph::graph_from_data_frame(edges, directed = FALSE, vertices = nodes)
  meta <- get_play_metadata(play = play, corpus = corpus)

  structure(graph,
    play = play,
    corpus = corpus,
    id = meta$id,
    wikidataId = meta$wikidataId,
    genre = meta$genre,
    num_of_segments = nrow(meta$segments),
    authors = paste0(meta$authors$name, collapse = "\n"),
    title = meta$title,
    year = meta$yearNormalized,
    class = c("coocur_igraph", "igraph")
  )
}

#' Test an object to be a 'coocur_igraph' object.
#'
#' Test that object is a \code{coocur_igraph}.
#'
#' @param x An R object.
#' @export
is.coocur_igraph <- function(x) {
  inherits(x, "coocur_igraph")
}

#' Extract labels for plotting 'coocur_igraph' object.
#'
#' Extract labels for plotting \code{coocur_igraph} object. \code{label_coocur_igraph}
#' gives control of overplotting for labels (i.e. character names) by deleting
#' extra labels if there are too many of them. This function can be used to set
#' \code{vertex.label} parameter for \code{\link{plot.coocur_igraph}}.
#'
#' \code{label_coocur_igraph} takes labels from a vertices data.frame column
#' \code{"name"}, checks that network size is more than \code{max_graph_size},
#' if it is true, returns names for top \code{top_nodes} and NA for the rest.
#'
#' @return Character vector of character names.
#' @param graph \code{coocur_igraph} object to plot.
#' @param max_graph_size Integer, maximum network size for plotting all labels.
#' @param top_nodes Integer, number of labels to be plotted. Characters with the
#'   highest number of words will be selected.
#' @param label_size_metric Character, a metric that is used to rank characters
#' in a play.
#' @examples
#' zhenitba_igraph <- get_coocur_igraph(play = "gogol-zhenitba", corpus = "rus")
#' label_coocur_igraph(zhenitba_igraph, max_graph_size = 10, top_nodes = 4)
#' @seealso \code{\link{get_coocur_igraph}}
#' @import igraph
#' @export
label_coocur_igraph <- function(graph,
                              max_graph_size = 30L,
                              top_nodes = 3L,
                              label_size_metric = c("betweenness",
                                            "numOfWords",
                                            "numOfScenes",
                                            "numOfSpeechActs",
                                            "degree",
                                            "weightedDegree",
                                            "closeness",
                                            "eigenvector")) {
  label_size_metric <- match.arg(label_size_metric)
  vertices_labels <- igraph::vertex_attr(graph, "name")
  if (igraph::vcount(graph) > max_graph_size) {
    vertices_labels[igraph::vcount(graph) - rank(igraph::vertex_attr(graph, label_size_metric),
                    ties.method = "max") >= top_nodes] <-
      NA_character_
  }
  vertices_labels
}

#' @param x A \code{coocur_igraph} object to plot.
#' @param vertex.label A character vector of character names. By default,
#' function \code{\link{label_coocur_igraph}} is used to avoid overplotting on
#' large graphs.
#' @param layout Function, an algorithm used for graph layout. See
#' \link[igraph]{igraph.plotting}.
#' @param gender_colors Named vector with 3 values with colors for
#' MALE, FEMALE and UNKNOWN respectively. Set \code{NULL} to use default igraph
#' colors. If you set parameter \code{vertex.color} (see
#' \link[igraph]{igraph.plotting}), \code{gender_colors} will be ignored.
#' @param vertex_size_metric Character value, one of \code{"numOfWords"},
#' \code{"numOfScenes"}, \code{"numOfSpeechActs"}, \code{"degree"},
#' \code{"weightedDegree"}, \code{"closeness"}, \code{"betweenness"},
#' \code{"eigenvector"}. You can specify vertex size by yourself using
#' parameter \code{"vertex.size"}(see \link[igraph]{igraph.plotting}), in this
#' case parameter \code{vertex_size_metric} is ignored.
#' @param vertex_size_scale Numeric vector with two values. The first number is
#' for mean size of node(vertex), the second one is for node size variance. If
#' you specify vertex size by yourself using parameter
#' \code{"vertex.size"}(see \link[igraph]{igraph.plotting}),
#' \code{vertex_size_scale} is ignored.
#' @param edge_size_scale Numeric vector with two values. The first number
#' defines average size of edges, the second number defines edges size variance.
#' If you specify edges size by yourself using parameter
#' \code{"edge.width"}(see \link[igraph]{igraph.plotting}),
#' \code{edge_size_scale} is ignored.
#' @param vertex.label.color See \link[igraph]{igraph.plotting}.
#' @param vertex.label.family See \link[igraph]{igraph.plotting}.
#' @param vertex.label.font See \link[igraph]{igraph.plotting}.
#' @param vertex.frame.color See \link[igraph]{igraph.plotting}.
#' @param ... Other arguments to be passed to \link[igraph]{plot.igraph}
#' @method plot coocur_igraph
#' @export
#' @describeIn get_coocur_igraph Plot \code{coocur_igraph} using \code{plot.igraph}
#' with slightly modified defaults.
plot.coocur_igraph <- function(x,
                               layout = igraph::layout_with_kk,
                               vertex.label = label_coocur_igraph(x),
                               gender_colors = c(MALE = "#0073C2",
                                                 FEMALE = "#EFC000",
                                                 UNKNOWN = "#99979D"),
                               vertex_size_metric = c(
                                 "numOfWords",
                                 "numOfScenes",
                                 "numOfSpeechActs",
                                 "degree",
                                 "weightedDegree",
                                 "closeness",
                                 "betweenness",
                                 "eigenvector"
                               ),
                               vertex_size_scale = c(5, 20),
                               edge_size_scale = c(.5, 4),
                               vertex.label.color = "#03070f",
                               vertex.label.family = "sans",
                               vertex.label.font = 2L,
                               vertex.frame.color = "white",
                               ...) {
  if (!exists("vertex.color")) {
    stopifnot(
      "gender_colors must be named vector with 3 values or NULL" =
        names(gender_colors) == c("MALE", "FEMALE", "UNKNOWN") |
        is.null(gender_colors)
    )
    if (is.null(gender_colors)) {
      vertex.color <- NULL
    } else {
      vertex.color = gender_colors[igraph::V(x)$gender]
    }
  }
  if (!exists("vertex.size")) {
    vertex_size_metric <- match.arg(vertex_size_metric)
    stopifnot(
      "vertex_size_scale must be numeric vector with 2 values" =
        length(vertex_size_scale) == 2 &
        is.numeric(vertex_size_scale)
    )
    v_s <- igraph::vertex_attr(x, vertex_size_metric)
    vertex.size <- (v_s - min(v_s)) / max(v_s) *
      vertex_size_scale[2] + vertex_size_scale[1]
  }

  vertex.shape <-
    c("circle", "square")[as.numeric(igraph::vertex_attr(x, "isGroup")) + 1]

  if (!exists("edge.width") & !is.null(edge_size_scale)) {
    stopifnot(
      "edge_size_scale must be numeric vector with 2 values" =
        length(edge_size_scale) == 2 &
        is.numeric(edge_size_scale)
    )
    w <- igraph::edge_attr(x, "weight")
    edge.width <-
      (w - min(w)) / max(w) * edge_size_scale[2] + edge_size_scale[1]
  }

  igraph::plot.igraph(
    x,
    vertex.color = vertex.color,
    vertex.size = vertex.size,
    vertex.shape = vertex.shape,
    vertex.frame.color = vertex.frame.color,
    vertex.label = vertex.label,
    vertex.label.color = vertex.label.color,
    vertex.label.family = vertex.label.family,
    vertex.label.font = vertex.label.font,
    edge.width = edge.width,
    layout = layout,
    ...
  )
}


#' @param object An object of class \code{"coocur_igraph"}.
#' @method summary coocur_igraph
#' @export
#' @describeIn get_coocur_igraph Meaningful summary for \code{"coocur_igraph"} object:
#'   network properties, gender distribution
summary.coocur_igraph <- function(object, ...) {
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

