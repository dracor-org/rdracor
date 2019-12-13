#helper functions ---
#' @import ggplot2
shortening_names <- function(name) gsub(",.*", "",name)

theme_rdracor_minimal <- theme_minimal()+
  theme(axis.title = element_blank(),
        panel.grid = element_blank())

top_authors <- function(authors, top_n = 5) {
  authors_short <- authors[1:min(nrow(authors), top_n),]
  paste(authors_short$N, authors_short$name, sep = " - ", collapse = "\t\n")
}

#functions for export

#' @import data.table
#' @exportClass authors
#' @export
authors <- function(corpus){
  N <- name <- `.` <- NULL #to pass check
  authors_dt <- rbindlist(corpus$authors)[,.N, by = .(key, name)][order(-N)]
  structure(authors_dt,
            name = attr(corpus, "name"),
            title = attr(corpus, "title"),
            repository = attr(corpus, "repository"),
            class = c("authors", class(authors_dt)))
}

#' @exportMethod is authors
#' @export
is.authors <- function(x) {
  inherits(x, "authors")
}

#' @exportMethod summary authors
#' @export
summary.authors <- function(object, ...){
  n <- nrow(object)
  cat(sprintf("There are %d authors in %s\t\n\nTop authors of the Corpus:\t\n%s",
              n, attr(object, "title"), top_authors(object)))
}

#' @exportMethod plot authors
#' @export
plot.authors <- function(x,
                         extract_surnames = FALSE,
                         top_n = nrow(x),
                         top_minplays = 1,
                         top_ratio = 1){
  N <- NULL #to pass check
  if(extract_surnames){
    x$name <- shortening_names(x$name)
  }
  top_authors <- min(ceiling(top_ratio*nrow(x)),
                     top_n,
                     nrow(x[N>=top_minplays,]))
  x <- x[1:top_authors,]
  ggplot(x, aes(x = key, y = N))+
    geom_segment(aes(xend = key, yend = 0))+
    geom_point()+
    coord_flip()+
    scale_x_discrete(limits = rev(x$key), labels = rev(x$name))+
    theme_rdracor_minimal
}
