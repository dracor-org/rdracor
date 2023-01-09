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
  structure(graph,
    play = play,
    corpus = corpus,
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
#' @examples
#' library(igraph)
#' zhenitba_igraph <- get_coocur_igraph(play = "gogol-zhenitba", corpus = "rus")
#' label_coocur_igraph(zhenitba_igraph, max_graph_size = 10, top_nodes = 4)
#' @seealso \code{\link{get_coocur_igraph}}
#' @import igraph
#' @export
label_coocur_igraph <- function(graph,
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

#' @param x A \code{coocur_igraph} object to plot.
#' @param vertex.label A character vector of character names.
#' @method plot coocur_igraph
#' @export
#' @describeIn get_coocur_igraph Plot \code{coocur_igraph} using \code{plot.igraph}
#' with slightly modified defaults.
plot.coocur_igraph <- function(x,
                               vertex.label = label_coocur_igraph(x),
                             ...) {
  gender_colours <- c(
    MALE = "#26B69E",
    FEMALE = "#9400E9",
    UNKNOWN = "#6F747E"
  )
  vertex.label <- vertex.label
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

