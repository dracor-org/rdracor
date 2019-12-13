# library(jsonlite)
#
#
# #fromJSON("https://dracor.org/api/metrics", flatten = T)
#
#
#
# #str(dracor(fromJSON("https://dracor.org/api/metrics", flatten = T)))
#
#
#
#
#
# drac <- get_dracor()
#
#
#
# plot(drac)
#
# corpus <- function(cor_fromjson){
#   cor_df <- type.convert(cor_fromjson$dramas, as.is = TRUE)
#   attributes(cor_df) <- c(attributes(cor_df),
#                           list(name = cor_fromjson$name,
#                                title = cor_fromjson$title,
#                                repository = cor_fromjson$repository))
#   class(cor_df) <- c("corpus", "data.frame")
#   cor_df
# }
#
# corpus <- function(cor_fromjson){
#   cor_df <- type.convert(cor_fromjson$dramas, as.is = TRUE)
#   structure(cor_df,
#             name = cor_fromjson$name,
#             title = cor_fromjson$title,
#             repository = cor_fromjson$repository,
#             class = c("corpus", "data.frame"))
# }
#
# tmp_german <- fromJSON("https://dracor.org/api/corpora/ger", flatten = T)
#
#
#
# tmp_corpus <- corpus(tmp)
# class(tmp_corpus)
# tmp_corpus
#
# written <- range(tmp_corpus$writtenYear, na.rm = T)
# premiere <- range(tmp_corpus$premiereYear, na.rm = T)
# printed <- range(tmp_corpus$printYear, na.rm = T)
# cat(sprintf("Written years: %d - %d", written[1], written[2]),
#     sprintf("Premiere years: %d - %d", premiere[1], premiere[2]),
#     sprintf("Years of the first printing: %d - %d", printed[1], printed[2]),
#     sprintf("%d plays in %s", nrow(tmp_corpus), attr(tmp_corpus, "title")),
#     sprintf("Corpus id: %s, repository: %s",
#             attr(tmp_corpus, "name"),
#             attr(tmp_corpus, "repository")),
#     #authors_count_sorted,
#     sep = "\t\n")
#
# authors_count <- as.data.frame(table(tmp_corpus$author.name))
# authors_count_sorted <- authors_count[order(-authors_count$Freq),]
# if (nrow(authors_count_sorted)>5){
#   authors_count_sorted <- authors_count_sorted[1:5,]
# }
#
#
#
#
# tmp_corpus
#
#
#
# germ <- corpus(tmp_german)
# ag <- authors(germ)
#
#
#
# # summary.authors <- function(authors){
# #   n <- nrow(authors)
# #   cat(sprintf("There are %d authors in %s\t\nRepository: %s",
# #       n, attr(authors, "title"), attr(authors, "repository")))
# # }
#
#
#
# summary(ag)
#
#
#
#
# plot(ag, extract_surnames = TRUE, top_n = 100, top_ratio = 0.2, top_minplays = 7)
#
# # agnew <- ag[1,2:3]
# # agnew[1:min(.N, 5),]
# # cat(paste(ag$N, ag$name, sep = " - ", collapse = "\t\n"))
#
# # agnew <- ag[1,2:3]
# # agnew[1:min(nrow(agnew), 5),]
# # agnew[1:min(.N, nrow(agnew)),]
# # agnew[1:5 ,]
# # paste(as.data.frame(ag))
# # as.data.frame(ag)
# # class(ag)
# # paste(ag)
# # str(ag)
# #
# # agnew <- ag[1,2:3]
# # agnew[1:min(.N, nrow(agnew)),]
# # paste()
# form_drama_request <- function(corpus = NULL, play = NULL, id = NULL, title = NULL, wikidataId = NULL,
#                                sourceURL = NULL, corpus_object = NULL){
#   #You must provide both corpus and name for a play. Example of the name for a play is "andreyev-ne-ubiy". Also, you can use
#   #id (e.g., "rus000138"), title (e.g., "Не убий") or wikidataId (e.g., "Q59357856") as specified in corpus.
# if (is.null(corpus)) {
#   stop("You need to provide a corpus")
# }
#
# if (!is.null(play)) {
#   request <- paste0("https://dracor.org/api/corpora/", corpus ,"/play/", play)
#   return(request)
# } else if (!is.null(name)){
#   get_corpus()
# }
# }
#
# form_play_request <- function(corpus = NULL, play = NULL, type = NULL){
#   if (is.null(corpus)) {
#     stop("You need to provide a corpus")
#   }
#   if (is.null(play)) {
#     stop("You need to provide a play")
#   }
#   request <- paste0("https://dracor.org/api/corpora/", corpus ,"/play/", play)
#   if (!is.null(type)){
#     return(paste(request, type, sep = "/"))
#   } else {
#     return(request)
#   }
# }
#
#
# get_play <- function(corpus = NULL, play = NULL) {
#   #You must provide both corpus and name for a play. Example of the name for a play is "andreyev-ne-ubiy".
#
#   play <- fromJSON(form_play_request(corpus, play))
# }
#
# library(igraph)
#
#
# get_play_igraph <- function(corpus = NULL, play = NULL) {
#   nodes <- fromJSON(form_play_request(corpus, play, "cast"))
#   nodes <- nodes[, c("id", names(nodes)[names(nodes) != "id"])]
#   edges <- fread(form_play_request(corpus, play, "networkdata/csv"),
#                  encoding = "UTF-8")
#   setnames(edges, tolower(names(edges)))
#   edges <- edges[,.(source, target, weight)]
#   graph <- graph_from_data_frame(edges, directed = FALSE, vertices = nodes)
#   structure(graph,
#             class = c("play_igraph", "igraph"))
# }
#
# is.play.igraph <- function(x) {
#   inherits(x, "play_igraph")
# }
#
# plot.play_igraph <- function(graph,
#                              gender_colours = c(MALE = "#26B69E",
#                                                 FEMALE = "#9400E9",
#                                                 UNKNOWN = "#6F747E"),
#                              ...) {
#   plot.igraph(graph,
#        vertex.label.color = "black",
#        vertex.color = gender_colours[V(graph)$gender],
#        ...)
# }
#
#
# graph <- z_ig
# gender_colours <- c(MALE = "#26B69E", FEMALE = "#9400E9", UNKNOWN = "#6F747E")
# gender_colours[V(graph)$gender]
#
# plot(graph,
#      vertex.label.color = "black",
#      vertex.color = gender_colours[V(graph)$gender])
#
# fromJSON("https://dracor.org/api/corpora/rus/play/gogol-zhenitba/metrics")
#
#
# fromJSON(form_drama_request(corpus = "rus", play = "gogol-zhenitba"), flatten = FALSE)
#
# get_drama_full_b(play_name, corpus, URL)
#
#
# zh <- fromJSON('https://dracor.org/api/corpora/rus/play/gogol-zhenitba', flatten = TRUE)
# zhtei <- xml2::read_xml('https://dracor.org/api/corpora/rus/play/gogol-zhenitba/tei')
# library(XML)
# zhparsed <- xmlParse(zhtei)
# class(zhparsed)
# install.packages("flatxml")
# library(flatxml)
# flat <- fxml_importXMLFlat('/Users/ivan/Downloads/tei.xml')
# fxml_toDataFrame(zhtei)
# library(xml2)
#
# library(igraph)
# library(data.table)
# data.table::fread("https://dracor.org/api/corpora/rus/play/gogol-zhenitba/tei")
# csv2d <- function(file){
#   d <- fread(file, encoding = "UTF-8")
#   colnames(d) <- tolower(colnames(d))
#   d <- d[,.(source, target, weight)]
#   d <- d[weight>0,]
#   d}
#
# cs <- csv2d("https://dracor.org/api/corpora/rus/play/gogol-zhenitba/networkdata/csv")
# d2ig <- function(d){
#   x <- graph_from_data_frame(d, directed = F)
#   V(x)$betweenness <- betweenness(x, v = V(x), directed = F, weights = NA)
#   V(x)$closeness <- closeness(x, weights = NA, normalized = T)
#   V(x)$strength <- strength(x)
#   V(x)$degree <- degree(x)
#   V(x)$average_distance <- 1/closeness(x, weights = NA, normalized = T)
#   x
# }
#
# ig <- d2ig(cs)
# summary(ig)
#
#
# ?graph_from_adjacency_matrix()
# diameter(boris)
# names(boris)
# boris$names <- boris$name
# setnames(boris, "name", "names")
# as_data_frame(boris, "vertices", vertices = NULL)
# graph.cohesion(boris)

