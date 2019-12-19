#' @export
get_play_metadata <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play),
             expected_format = "application/json", ...)
}

#' @export
get_play_metrics <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "metrics"),
             expected_format = "application/json",
             ...)
}

#' @importFrom xml2 read_xml
#' @export
get_play_tei <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "tei"),
             expected_format = "application/xml",
             ...)
}


#' @export
get_play_rdf <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "rdf"),
             expected_format = "application/xml",
             ...)
}

#' @export
get_play_cast <- function(corpus = NULL, play = NULL, ...) {
  dracor_api(form_play_request(corpus, play, type = "cast"),
             expected_format = "application/json",
             ...)
}

#' @export
get_play_networkdata_csv <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(
      form_play_request(corpus, play, type = "networkdata/csv"),
      expected_format = "text/csv",
      data.table = FALSE,
      encoding = "UTF-8",
      ...
    )
  }

#' @export
get_play_networkdata_gexf <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(form_play_request(corpus, play, type = "networkdata/gexf"),
               expected_format = "application/xml",
               ...)
  }

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
               expected_format = "text/plain", ...)
  }

#' @export
get_play_spoken_text_bych <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(
      form_play_request(corpus, play, type = "spoken-text-by-character"),
      expected_format = "application/json",
      ...
    )
  }

#' @export
get_play_stage_directions <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(form_play_request(corpus, play, type = "stage-directions"),
               expected_format = "text/plain",
               ...)
  }

#' @export
get_play_stage_directions_with_sp <-
  function(corpus = NULL, play = NULL, ...) {
    dracor_api(
      form_play_request(corpus, play, type = "stage-directions-with-speakers"),
      expected_format = "text/plain",
      ...
    )
  }

#' @importFrom utils URLencode
#' @export
get_sparql <- function(sparql_query = NULL, ...) {
  if (is.null(sparql_query)) {
    stop("SPARQL query must be provided")
  }
  query <- paste0("https://dracor.org/api/sparql?query=",
                  URLencode(sparql_query, reserved = TRUE))
  dracor_api(query, expected_format = "application/xml", ...)
}

#' @import igraph
#' @exportClass play_igraph
#' @export
get_play_igraph <- function(corpus = NULL, play = NULL) {
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

is.play_igraph <- function(x) {
  inherits(x, "play_igraph")
}

#' @export
label_play_graph <- function(graph,
                             top_nodes = 3,
                             max_graph = 30) {
  vertices_labels <- V(graph)$name
  if (vcount(graph) > max_graph) {
    vertices_labels[vcount(graph) - rank(V(graph)$numOfWords, ties.method = "max") >= top_nodes] <-
      NA
  }
  vertices_labels
}

#' @method plot play_igraph
#' @export
plot.play_igraph <- function(x,
                             gender_colours = c(MALE = "#26B69E",
                                                FEMALE = "#9400E9",
                                                UNKNOWN = "#6F747E"),
                             vertex.label = label_play_graph(x),
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
