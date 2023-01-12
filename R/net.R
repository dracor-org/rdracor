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
#' constructed based on characters' co-occurrence matrix. Each node (vertex) is
#' a character (circle) or a group of characters (square), edges width is
#' proportional to number of common play segments where two characters occur
#' together.
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
    authors = paste0(meta$authors$name, collapse = ", "),
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
#' @param layout Function, an algorithm used for graph layout. See
#' \link[igraph]{igraph.plotting}.
#' @param vertex.label A character vector of character names. By default,
#' function \code{\link{label_coocur_igraph}} is used to avoid overplotting on
#' large graphs.
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
#' @param vertex_label_adjust Logical value. If \code{TRUE}, labels positions
#' are moved to the top of the respectives nodes. If \code{FALSE}, labels
#' are placed in the nodes centers. \code{TRUE} by default. If you set parameter
#' \code{vertex.label.dist}(see \link[igraph]{igraph.plotting}) by yourself,
#' \code{vertex_label_adjust} is ignored.
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
                               vertex_label_adjust = TRUE,
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
      vertex.color = gender_colors[igraph::vertex_attr(x, "gender")]
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

  if (!exists("vertex.label.dist"))
  {
    stopifnot(
      "vertex_label_adjust must be TRUE or FALSE" =
        isTRUE(vertex_label_adjust) |
        isFALSE(vertex_label_adjust)
    )
    if (vertex_label_adjust) {
      vertex.label.dist <- vertex.size / 10 + .75
    } else {
      vertex.label.dist <- 0
    }
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
    vertex.label.dist = vertex.label.dist,
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
  genders <- igraph::vertex_attr(object, "gender")
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
      "%s: %s - coocurence network summary",
      attr(object, "corpus"),
      attr(object, "play")
    ),
    sprintf("%s: %s (%i)",
            attr(object, "authors"),
            attr(object, "title"),
            attr(object, "year")),
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

#' Retrieve an igraph relations network for a play.
#'
#' Returns a play network, given corpus and play names. The network represent
#' kinship and other relationships data, following the encoding scheme proposed
#' in \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#'
#' @return \code{relations_igraph} Object that inherits \code{igraph} and can be
#' treated as such.
#' @inheritParams get_play_metadata
#' @examples
#' zhen_rel <- get_relations_igraph(play = "gogol-zhenitba", corpus = "rus")
#' plot(zhen_rel)
#' @seealso \code{\link{get_play_metadata}}
#' @import igraph
#' @import data.table
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
#' @export

get_relations_igraph <- function(play = play, corpus = corpus) {
  relations <-
    get_net_relations_edges(play = play,
                        corpus = corpus,
                        as_tibble = FALSE)
  nodes <-
    get_play_cast(play = play,
                  corpus = corpus,
                  as_tibble = FALSE)
  data.table::setnames(relations, c("source", "type", "target", "relation"))
  graph <- igraph::graph.data.frame(relations[, c("source", "target", "type", "relation")],
                                    directed = TRUE,
                                    vertices = nodes)
  meta <- get_play_metadata(play = play, corpus = corpus)
  structure(
    graph,
    play = play,
    corpus = corpus,
    id = meta$id,
    wikidataId = meta$wikidataId,
    genre = meta$genre,
    num_of_segments = nrow(meta$segments),
    authors = paste0(meta$authors$name, collapse = "\n"),
    title = meta$title,
    year = meta$yearNormalized,
    character_ids = nodes$id,
    node_with_relations = unique(c(relations$source, relations$target)),
    class = c("relations_igraph", "igraph")
  )
}

#' Test an object to be a 'relations_igraph' object.
#'
#' Test that object is a \code{relations_igraph}.
#'
#' @param x An R object.
#' @export
is.relations_igraph <- function(x) {
  inherits(x, "relations_igraph")
}

#' @param object An object of class \code{"relations_igraph"}.
#' @method summary relations_igraph
#' @export
#' @describeIn get_relations_igraph Meaningful summary for
#' \code{"relations_igraph"} object: relationships and their type.
summary.relations_igraph <- function(object, ...) {
  genders <- igraph::vertex_attr(object, "gender")
  edges_df <- as_data_frame(object)
  n <- nrow(edges_df)
  edges_df$arrow <-
    ifelse(edges_df$type == "Directed", "--->", "<-->")
  edges_text <-
    paste(edges_df$from,
          edges_df$arrow,
          edges_df$to,
          ":",
          edges_df$relation)
  cat(
    sprintf(
      "%s: %s - relations network summary",
      attr(object, "corpus"),
      attr(object, "play")
    ),
    sprintf(
      "%s: %s (%i)",
      attr(object, "authors"),
      attr(object, "title"),
      attr(object, "year")
    ),
    sprintf(""),
    sprintf(
      "Size: %i (%i FEMALES, %i MALES, %i UNKNOWN)",
      length(genders),
      sum(genders == "FEMALE"),
      sum(genders == "MALE"),
      sum(genders == "UNKNOWN")
    ),
    sprintf("Relations: %i", n),
    if (n > 6) {
      sprintf(paste(c(head(edges_text, 6), "...and %i more"),
                    collapse = "\n"), n - 6)
    } else {
      sprintf(paste(edges_text, collapse = "\n"))
    },
    sep = "\t\n"
  )
}

#' @param x A \code{relations_igraph} object to plot.
#' @param layout Function, an algorithm used for graph layout. See
#' \link[igraph]{igraph.plotting}.
#' @param gender_colors Named vector with 3 values with colors for
#' MALE, FEMALE and UNKNOWN respectively. Set \code{NULL} to use default igraph
#' colors. If you set parameter \code{vertex.color} (see
#' \link[igraph]{igraph.plotting}), \code{gender_colors} will be ignored.
#' @param show_others Character value. What to do with verteces without
#' relations?
#' \itemize{
#'    \item \code{"vertex"}: plot only vertices without labels.
#'    \item \code{"vertex_label"}: plot both vertices and labels.
#'    \item \code{"none"}: do not plot vertices without relations.
#' }
#' The default is \code{"vertex"}.
#' @param vertex_size Numeric vector with two values. The first number is for
#' nodes with relations, the second number is for all other nodes.
#' @param vertex_label_size Numeric vector with two values. The first number
#' defines label sizes for nodes with relations, the second number for nodes
#' without relations.
#' @param vertex_label_adjust Logical value. If \code{TRUE}, labels positions
#' are moved to the top of the respectives nodes. If \code{FALSE}, labels
#' are placed in the nodes centers. \code{TRUE} by default. If you set parameter
#' \code{vertex.label.dist}(see \link[igraph]{igraph.plotting}) by yourself,
#' \code{vertex_label_adjust} is ignored.
#' @param vertex.label.color See \link[igraph]{igraph.plotting}.
#' @param vertex.label.family See \link[igraph]{igraph.plotting}.
#' @param vertex.label.font See \link[igraph]{igraph.plotting}.
#' @param vertex.frame.color See \link[igraph]{igraph.plotting}.
#' @param edge.arrow.size See \link[igraph]{igraph.plotting}.
#' @param edge.arrow.width See \link[igraph]{igraph.plotting}.
#' @param edge.curved See \link[igraph]{igraph.plotting}.
#' @param edge.label.family See \link[igraph]{igraph.plotting}.
#' @param edge.label.font See \link[igraph]{igraph.plotting}.
#' @param edge.label.cex See \link[igraph]{igraph.plotting}.
#' @param ... Other arguments to be passed to \link[igraph]{plot.igraph}
#' @method plot relations_igraph
#' @export
#' @describeIn get_relations_igraph Plot \code{relations_igraph} using
#' \code{plot.igraph} with slightly modified defaults.
plot.relations_igraph <- function(x,
                                  layout = igraph::layout_randomly,
                                  gender_colors = c(MALE = "#0073C2",
                                                    FEMALE = "#EFC000",
                                                    UNKNOWN = "#99979D"),
                                  show_others = c("vertex", "vertex_label", "none"),
                                  vertex_size = c(20, 6),
                                  vertex_label_size = c(1, .5),
                                  vertex_label_adjust = TRUE,
                                  vertex.label.color = "#03070f",
                                  vertex.label.family = "sans",
                                  vertex.label.font = 2L,
                                  vertex.frame.color = "white",
                                  edge.arrow.size = .5,
                                  edge.arrow.width = 1.5,
                                  edge.curved = .15,
                                  edge.label.family = "sans",
                                  edge.label.font = 4L,
                                  edge.label.cex = .75,
                                  ...) {

  nodes_with_relations <- attr(x, "node_with_relations")
  character_ids <- attr(x, "character_ids")
  show_others <- match.arg(show_others)

  if (show_others == "vertex") {
    vertex.label.cex <- ifelse(character_ids %in% nodes_with_relations,
                               vertex_label_size[1],
                               0.01)
    vertex.size <- ifelse(character_ids %in% nodes_with_relations,
                          vertex_size[1],
                          vertex_size[2])
  } else if (show_others == "vertex_label") {
    vertex.label.cex <- ifelse(
      character_ids %in% nodes_with_relations,
      vertex_label_size[1],
      vertex_label_size[2]
    )
    vertex.size <- ifelse(character_ids %in% nodes_with_relations,
                          vertex_size[1],
                          vertex_size[2])
  } else {
    vertex.label.cex <- ifelse(character_ids %in% nodes_with_relations,
                               vertex_label_size[1],
                               0.01)
    vertex.size <- ifelse(character_ids %in% nodes_with_relations,
                          vertex_size[1],
                          0)
  }

  edge.arrow.mode <- ifelse(E(x)$type == "Undirected", "-", ">")

  if (!exists("vertex.color")) {
    stopifnot(
      "gender_colors must be named vector with 3 values or NULL" =
        names(gender_colors) == c("MALE", "FEMALE", "UNKNOWN") |
        is.null(gender_colors)
    )
    if (is.null(gender_colors)) {
      vertex.color <- NULL
    } else {
      vertex.color = gender_colors[igraph::vertex_attr(x, "gender")]
    }
  }
  if (!exists("vertex.label.dist")) {
    stopifnot(
      "vertex_label_adjust must be TRUE or FALSE" =
        isTRUE(vertex_label_adjust) |
        isFALSE(vertex_label_adjust)
    )
    if (vertex_label_adjust) {
      vertex.label.dist <- vertex.size / 10 + .75
    } else {
      vertex.label.dist <- 0
    }
  }

  vertex.shape <-
    c("circle", "square")[as.numeric(igraph::vertex_attr(x, "isGroup")) + 1]

  E(x)$color <- data.table::fcase(
    E(x)$relation == "parent_of", "#6f42c1",
    E(x)$relation == "lover_of", "#f93e3e",
    E(x)$relation == "related_with", "#fca130",
    E(x)$relation == "associated_with", "#61affe",
    E(x)$relation == "siblings", "#49cc90",
    E(x)$relation == "spouses", "#e83e8c",
    E(x)$relation == "friends", "#1F2448"
  )
  igraph::plot.igraph(
    x,
    layout = layout,
    vertex.size = vertex.size,
    vertex.shape = vertex.shape,
    vertex.color = vertex.color,
    vertex.label.color = vertex.label.color,
    vertex.label.family = vertex.label.family,
    vertex.label.cex =  vertex.label.cex,
    vertex.label.font = vertex.label.font,
    vertex.frame.color = vertex.frame.color,
    edge.arrow.mode = edge.arrow.mode,
    vertex.label.dist = vertex.label.dist,
    edge.color = edge_attr(x, "color"),
    edge.curved = edge.curved,
    edge.arrow.size = edge.arrow.size,
    edge.arrow.width = edge.arrow.width,
    edge.label = edge_attr(x, "relation"),
    edge.label.color = edge_attr(x, "color"),
    edge.label.font = edge.label.font,
    edge.label.font = edge.label.font,
    edge.label.cex = edge.label.cex
  )
}

