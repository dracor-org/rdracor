#' Retrieve co-occurrence network metrics for a play
#'
#' \code{get_net_cooccur_metrics()} requests network metrics for a specific play,
#' given play and corpus names. Play network is constructed based on characters'
#' co-occurrence matrix.
#'
#' @return List with network metrics for a specific play.
#' @inheritParams get_play_characters
#' @examples
#' get_net_cooccur_metrics(play = "lessing-emilia-galotti", corpus = "ger")
#' @seealso \code{\link{get_net_cooccur_igraph}}
#' \code{\link{get_net_cooccur_gexf}} \code{\link{get_net_cooccur_graphml}}
#' \code{\link{get_net_cooccur_edges}} \code{\link{get_net_relations_igraph}}
#' @importFrom purrr modify_at
#' @importFrom tibble as_tibble
#' @export
get_net_cooccur_metrics <- function(play = NULL, corpus = NULL, ...) {
  metrics <- dracor_api(
    form_play_request(
      play = play,
      corpus = corpus,
      type = "metrics"
    ),
    expected_type = "application/json",
    as_tibble = FALSE,
    ...
  )
  purrr::modify_if(metrics, is.data.frame, tibble::as_tibble)
}

#' Retrieve co-occurrence edges list for a play as a data frame
#'
#' \code{get_net_cooccur_edges()} requests edges list for a play network, given
#' corpus and play names. Each row represents co-occurrences of two characters
#' in a play — number of scenes where two characters appeared together. This
#' edges list can be used to construct a network for a play.
#'
#' @return data frame with edges (each row = one edge of a network).
#' @inheritParams get_play_characters
#' @examples
#' get_net_cooccur_edges(play = "lessing-emilia-galotti", corpus = "ger")
#' @seealso \code{\link{get_net_cooccur_igraph}}
#' \code{\link{get_net_cooccur_gexf}} \code{\link{get_net_cooccur_graphml}}
#' \code{\link{get_net_cooccur_metrics}} \code{\link{get_net_relations_igraph}}
#' @export
get_net_cooccur_edges <-
  function(play = NULL, corpus = NULL, ...) {
    dracor_api(
      form_play_request(play = play, corpus = corpus, type = "networkdata/csv"),
      expected_type = "text/csv",
      data.table = FALSE,
      encoding = "UTF-8",
      ...
    )
  }

#' Retrieve co-occurrence network for a play in 'GEXF'
#'
#' \code{get_net_cooccur_gexf()} requests a play co-occurrence network in 'GEXF'
#' (Graph Exchange XML Format), given play and corpus names. 'GEXF' is a format
#' used in 'Gephi' — an open source software for network analysis and
#' visualization.
#'
#' @return 'GEXF' data.
#' @inheritParams get_play_characters
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @examples
#' \donttest{
#' get_net_cooccur_gexf(play = "lessing-emilia-galotti", corpus = "ger")
#' # If you want 'GEXF' without parsing by xml2::read_xml():
#' get_net_cooccur_gexf(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger",
#'   parse = FALSE
#' )
#' }
#' @seealso \code{\link{get_net_cooccur_igraph}}
#' \code{\link{get_net_cooccur_metrics}} \code{\link{get_net_cooccur_graphml}}
#' \code{\link{get_net_cooccur_edges}} \code{\link{get_net_relations_igraph}}
#' @export
get_net_cooccur_gexf <-
  function(play = NULL, corpus = NULL, parse = TRUE, ...) {
    dracor_api(
      form_play_request(
        play = play, corpus = corpus,
        type = "networkdata/gexf"
      ),
      expected_type = "application/xml",
      parse = parse,
      ...
    )
  }

#' Retrieve co-occurrence network for a play in 'GraphML'
#'
#' \code{get_net_cooccur_graphml()} requests a play co-occurrence network in
#' 'GraphML', given play and corpus names. 'GraphML' is a common format for
#' graphs based on XML.
#'
#' @return 'GraphML' data.
#' @inheritParams get_play_characters
#' @param parse Logical, if \code{TRUE} the result is parsed by
#' {\code{\link[xml2:read_xml]{xml2::read_xml()}}}, otherwise character value is
#' returned. Default value is \code{TRUE}.
#' @examples
#' \donttest{
#' get_net_cooccur_graphml(play = "lessing-emilia-galotti", corpus = "ger")
#' # If you want 'GEXF' without parsing by xml2::read_xml():
#' get_net_cooccur_graphml(play = "lessing-emilia-galotti", corpus = "ger", parse = FALSE)
#' }
#' @seealso \code{\link{get_net_cooccur_igraph}}
#' \code{\link{get_net_cooccur_gexf}} \code{\link{get_net_cooccur_metrics}}
#' \code{\link{get_net_cooccur_edges}} \code{\link{get_net_relations_igraph}}
#' @export
get_net_cooccur_graphml <-
  function(play = NULL, corpus = NULL, parse = TRUE, ...) {
    dracor_api(
      form_play_request(
        play = play,
        corpus = corpus,
        type = "networkdata/graphml"
      ),
      expected_type = "application/xml",
      parse = parse,
      ...
    )
  }

#' @export
#' @describeIn get_net_cooccur_edges Retrieves kinship and other relationship
#' data, following the encoding scheme proposed in
#' \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
get_net_relations_edges <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(form_play_request(play = play, corpus = corpus, type = "relations/csv"),
    expected_type = "text/csv",
    ...
  )
}

#' @export
#' @describeIn get_net_cooccur_gexf Retrieves kinship and other relationship
#' data, following the encoding scheme proposed in
#' \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
get_net_relations_gexf <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(
    form_play_request(
      play = play,
      corpus = corpus,
      type = "relations/gexf"
    ),
    expected_type = "application/xml",
    ...
  )
}

#' @export
#' @describeIn get_net_cooccur_graphml Retrieves kinship and other relationship
#' data, following the encoding scheme proposed in
#' \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
get_net_relations_graphml <- function(play = NULL, corpus = NULL, ...) {
  dracor_api(
    form_play_request(
      play = play,
      corpus = corpus,
      type = "relations/graphml"
    ),
    expected_type = "application/xml",
    ...
  )
}

#' Retrieve an igraph co-occurrence network for a play
#'
#' \code{get_net_cooccur_igraph()} returns a play network, given play and corpus
#' names. Play network is constructed based on characters' co-occurrence matrix.
#' Each node (vertex) is a character (circle) or a group of characters (square),
#' edges width is proportional to the number of common play segments where two
#' characters occur together.
#'
#' @param as_igraph Logical, if \code{TRUE}, returns simple igraph object
#' instead of \code{cooccur_igraph}. \code{FALSE} by default.
#'
#' @return \code{cooccur_igraph} — an object that inherits \code{igraph} and can be
#' treated as such.
#' @inheritParams get_play_characters
#' @examples
#' \donttest{
#' emilia_igraph <- get_net_cooccur_igraph(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger"
#' )
#' igraph::diameter(emilia_igraph)
#' plot(emilia_igraph)
#' summary(emilia_igraph)
#' }
#' @seealso \code{\link{get_net_relations_igraph}}
#' \code{\link{label_cooccur_igraph}}
#' @import igraph
#' @import data.table
#' @export
get_net_cooccur_igraph <- function(play = NULL,
                                   corpus = NULL,
                                   as_igraph = FALSE) {
  nodes <- get_play_characters(play = play, corpus = corpus, as_tibble = FALSE)
  edges <- get_net_cooccur_edges(play = play, corpus = corpus, as_tibble = FALSE)
  data.table::setnames(edges, tolower(names(edges)))
  edges <- edges[, c("source", "target", "weight")]
  graph <-
    igraph::graph_from_data_frame(edges, directed = FALSE, vertices = nodes)

  if (as_igraph) return(graph)

  meta <- get_play_metadata(play = play, corpus = corpus, full_metadata = FALSE)

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
    class = c("cooccur_igraph", "igraph")
  )
}

is.cooccur_igraph <- function(x) {
  inherits(x, "cooccur_igraph")
}

#' Extract labels for plotting 'cooccur_igraph' object
#'
#' \code{label_cooccur_igraph()} returns labels for plotting \code{cooccur_igraph}
#' object. \code{label_cooccur_igraph}
#' gives control of overplotting for labels (i.e. character names) by deleting
#' extra labels if there are too many of them. Thus, it highlights the most
#' significant characters of the selected play. This function can be used to set
#' \code{vertex.label} parameter for \code{\link{plot.cooccur_igraph}}.
#'
#' \code{label_cooccur_igraph} takes labels from a vertices data frame column
#' \code{"name"}, checks that network size is more than \code{max_graph_size},
#' if it is true, returns names for top \code{top_nodes} and NA for the rest.
#'
#' @return Character vector of character names.
#' @param graph \code{cooccur_igraph} object to plot.
#' @param max_graph_size Integer, maximum network size for plotting all labels.
#' If you don't want to delete any labels, set \code{Inf}.
#' @param top_nodes Integer, number of labels to be plotted. Characters with the
#'   highest number of words will be selected.
#' @param label_size_metric Character, a metric that is used to rank characters
#' in a play.
#' @examples
#' \donttest{
#' emilia_igraph <- get_net_cooccur_igraph(
#'   play = "lessing-emilia-galotti",
#'   corpus = "ger"
#' )
#' label_cooccur_igraph(emilia_igraph, max_graph_size = 10, top_nodes = 4)
#' }
#' @seealso \code{\link{get_net_cooccur_igraph}}
#' @import igraph
#' @export
label_cooccur_igraph <- function(graph,
                                max_graph_size = 30L,
                                top_nodes = 3L,
                                label_size_metric = c(
                                  "betweenness",
                                  "numOfWords",
                                  "numOfScenes",
                                  "numOfSpeechActs",
                                  "degree",
                                  "weightedDegree",
                                  "closeness",
                                  "eigenvector"
                                )) {
  label_size_metric <- match.arg(label_size_metric)
  vertices_labels <- igraph::vertex_attr(graph, "name")
  if (igraph::vcount(graph) > max_graph_size) {
    vertices_labels[igraph::vcount(graph) -
      rank(igraph::vertex_attr(graph, label_size_metric),
        ties.method = "max"
      ) >= top_nodes] <-
      NA_character_
  }
  vertices_labels
}

#' @param x A \code{cooccur_igraph} object to plot.
#' @param layout Function, an algorithm used for the graph layout. See
#' \link[igraph]{igraph.plotting}.
#' @param vertex.label Character vector of character names. By default,
#' function \code{\link{label_cooccur_igraph}} is used to avoid overplotting on
#' large graphs.
#' @param gender_colors Named vector with 3 values with colors for
#' MALE, FEMALE and UNKNOWN respectively. Set \code{NULL} to use the default
#' igraph colors. If you set parameter \code{vertex.color} (see
#' \link[igraph]{igraph.plotting}), \code{gender_colors} will be ignored.
#' @param vertex_size_metric Character value, one of \code{"numOfWords"},
#' \code{"numOfScenes"}, \code{"numOfSpeechActs"}, \code{"degree"},
#' \code{"weightedDegree"}, \code{"closeness"}, \code{"betweenness"},
#' \code{"eigenvector"} that will be used as a metric for vertex size.
#' Alternatively, you can specify vertex size by yourself using
#' parameter \code{vertex.size}(see \link[igraph]{igraph.plotting}), in this
#' case parameter \code{vertex_size_metric} is ignored.
#' @param vertex_size_scale Numeric vector with two values. The first number is
#' for mean size of node(vertex), the second one is for node size variance. If
#' you specify vertex size by yourself using parameter
#' \code{vertex.size}(see \link[igraph]{igraph.plotting}),
#' \code{vertex_size_scale} is ignored.
#' @param edge_size_scale Numeric vector with two values. The first number
#' defines average size of edges, the second number defines edges size variance.
#' If you specify edges size by yourself using parameter
#' \code{edge.width}(see \link[igraph]{igraph.plotting}),
#' \code{edge_size_scale} is ignored.
#' @param vertex_label_adjust Logical. If \code{TRUE}, labels positions
#' are moved to the top of the respectives nodes. If \code{FALSE}, labels
#' are placed in the nodes centers. \code{TRUE} by default. If you set parameter
#' \code{vertex.label.dist}(see \link[igraph]{igraph.plotting}) by yourself,
#' \code{vertex_label_adjust} is ignored.
#' @param vertex.label.color See \link[igraph]{igraph.plotting}.
#' @param vertex.label.family See \link[igraph]{igraph.plotting}.
#' @param vertex.label.font See \link[igraph]{igraph.plotting}.
#' @param vertex.frame.color See \link[igraph]{igraph.plotting}.
#' @param ... Other arguments to be passed to \link[igraph]{plot.igraph}
#' @method plot cooccur_igraph
#' @export
#' @describeIn get_net_cooccur_igraph Plot \code{cooccur_igraph} using
#' \code{plot.igraph} with slightly modified defaults.
plot.cooccur_igraph <- function(x,
                               layout = igraph::layout_with_kk,
                               vertex.label = label_cooccur_igraph(x),
                               gender_colors = c(
                                 MALE = "#0073C2",
                                 FEMALE = "#EFC000",
                                 UNKNOWN = "#99979D"
                               ),
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
      vertex.color <- gender_colors[igraph::vertex_attr(x, "gender")]
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


#' @param object An object of class \code{cooccur_igraph}.
#' @method summary cooccur_igraph
#' @export
#' @describeIn get_net_cooccur_igraph Meaningful summary for
#'   \code{"cooccur_igraph"} object: network properties, gender distribution
summary.cooccur_igraph <- function(object, ...) {
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
      "%s: %s - co-ocurence network summary",
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

#' Retrieve an igraph relations network for a play
#'
#' \code{get_net_relations_igraph()} a play network, given play and corpus names
#' . The network represent kinship and other relationships data, following the
#' encoding scheme proposed in
#' \insertCite{wiedmer_nathalie_2020_4621778}{rdracor}.
#'
#' @param as_igraph Logical, if \code{TRUE}, returns simple igraph object
#' instead of \code{cooccur_igraph}. \code{FALSE} by default.
#'
#' @return \code{relations_igraph} — an object that inherits \code{igraph} and
#' can be treated as such.
#' @inheritParams get_play_characters
#' @examples
#' \donttest{
#' nedorosl_relations <- get_net_relations_igraph(
#'   play = "fonvizin-nedorosl",
#'   corpus = "rus"
#' )
#' plot(nedorosl_relations)
#' summary(nedorosl_relations)
#' }
#' @seealso \code{\link{get_net_cooccur_igraph}}
#' @import igraph
#' @import data.table
#' @importFrom Rdpack reprompt
#' @references
#'   \insertAllCited{}
#' @export
get_net_relations_igraph <- function(play = play,
                                     corpus = corpus,
                                     as_igraph = FALSE) {
  relations <-
    get_net_relations_edges(
      play = play,
      corpus = corpus,
      as_tibble = FALSE
    )
  nodes <-
    get_play_characters(
      play = play,
      corpus = corpus,
      as_tibble = FALSE
    )
  data.table::setnames(relations, c("source", "type", "target", "relation"))
  graph <- igraph::graph.data.frame(
    relations[, c(
      "source",
      "target",
      "type",
      "relation"
    )],
    directed = TRUE,
    vertices = nodes
  )

  if (as_igraph) return(graph)

  meta <- get_play_metadata(play = play, corpus = corpus, full_metadata = FALSE)
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

is.relations_igraph <- function(x) {
  inherits(x, "relations_igraph")
}

#' @param object An object of class \code{relations_igraph}.
#' @method summary relations_igraph
#' @export
#' @describeIn get_net_relations_igraph Meaningful summary for
#' \code{"relations_igraph"} object: relationships and their type.
summary.relations_igraph <- function(object, ...) {
  genders <- igraph::vertex_attr(object, "gender")
  edges_df <- as_data_frame(object)
  n <- nrow(edges_df)
  edges_df$arrow <-
    ifelse(edges_df$type == "Directed", "--->", "<-->")
  edges_text <-
    paste(
      edges_df$from,
      edges_df$arrow,
      edges_df$to,
      ":",
      edges_df$relation
    )
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
        collapse = "\n"
      ), n - 6)
    } else {
      sprintf(paste(edges_text, collapse = "\n"))
    },
    sep = "\t\n"
  )
}

#' @param x A \code{relations_igraph} object to plot.
#' @param layout Function, an algorithm used for graph layout. See
#' \link[igraph]{layout_}.
#' @param gender_colors Named vector with 3 values with colors for
#' MALE, FEMALE and UNKNOWN respectively. Set \code{NULL} to use default igraph
#' colors. If you set parameter \code{vertex.color} (see
#' \link[igraph]{igraph.plotting}), \code{gender_colors} will be ignored.
#' @param show_others Character value. What to do with vertices without
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
#' are moved to the top of the respective nodes. If \code{FALSE}, labels
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
#' @describeIn get_net_relations_igraph Plot \code{relations_igraph} using
#' \code{plot.igraph} with slightly modified defaults.
plot.relations_igraph <- function(x,
                                  layout = igraph::layout_nicely,
                                  gender_colors = c(
                                    MALE = "#0073C2",
                                    FEMALE = "#EFC000",
                                    UNKNOWN = "#99979D"
                                  ),
                                  show_others = c(
                                    "vertex",
                                    "vertex_label",
                                    "none"
                                  ),
                                  vertex_size = c(13, 4),
                                  vertex_label_size = c(.8, .5),
                                  vertex_label_adjust = TRUE,
                                  vertex.label.color = "#03070f",
                                  vertex.label.family = "sans",
                                  vertex.label.font = 2L,
                                  vertex.frame.color = "white",
                                  edge.arrow.size = .25,
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
      0.01
    )
    vertex.size <- ifelse(character_ids %in% nodes_with_relations,
      vertex_size[1],
      vertex_size[2]
    )
  } else if (show_others == "vertex_label") {
    vertex.label.cex <- ifelse(
      character_ids %in% nodes_with_relations,
      vertex_label_size[1],
      vertex_label_size[2]
    )
    vertex.size <- ifelse(character_ids %in% nodes_with_relations,
      vertex_size[1],
      vertex_size[2]
    )
  } else {
    vertex.label.cex <- ifelse(character_ids %in% nodes_with_relations,
      vertex_label_size[1],
      0.01
    )
    vertex.size <- ifelse(character_ids %in% nodes_with_relations,
      vertex_size[1],
      0
    )
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
      vertex.color <- gender_colors[igraph::vertex_attr(x, "gender")]
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
    vertex.label.cex = vertex.label.cex,
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
