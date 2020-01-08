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

#' Retrieve authors and number of plays they have for a corpus
#'
#' \code{authors} returns \code{authors} object that inherits data.frame. For
#' each author in a corpus her/his respective number of plays is calculated.
#'
#' There are more than one author for a play in some cases (e.g., in German
#' Drama Corpus). Coauthorship is not "weighted" for these plays: for each
#' author a play is counted as one play. Thus, a sum of all plays by al writers
#' in \code{authors} can be more than a number of plays in a corpus.
#'
#' @return \code{authors} object that inherits data.frame (and can be used
#'   as such).
#' @param corpus \code{corpus} object or corpus name as character. Vector of corpus
#'   names is not supported
#' @examples
#' ru <- get_corpus("rus")
#' ru_authors <- authors(ru)
#' summary(ru_authors)
#' @import data.table
#' @exportClass authors
#' @export
authors <- function(corpus){
  N <- name <- `.` <- NULL #to pass check
  if (is.character(corpus)) {
    corpus <- get_corpus(corpus)
  } else if (is.corpus(corpus)) {
    invisible()
  } else {
    stop("corpus parameter is neither valid corpus name nor corpus object")
  }
  authors_dt <- rbindlist(corpus$authors)[,.N, by = .(key, name)][order(-N)]
  structure(authors_dt,
            name = attr(corpus, "name"),
            title = attr(corpus, "title"),
            repository = attr(corpus, "repository"),
            class = c("authors", "data.frame"))
}

#' @method is authors
#' @export
#' @describeIn authors Tests that object is \code{authors}.
is.authors <- function(x) {
  inherits(x, "authors")
}

#' @method summary authors
#' @export
#' @describeIn authors Meaningful summary for \code{authors} object
summary.authors <- function(object, ...){
  n <- nrow(object)
  cat(sprintf("There are %d authors in %s\t\n\nTop authors of the Corpus:\t\n%s",
              n, attr(object, "title"), top_authors(object)))
}

#' Plot number of plays by authors of the corpus
#'
#' \code{plot.authors} plots numbers of plays for every author or only for
#' top authors.
#'
#' There are some really long names, in case you want to plot authors with their
#' surnames only, use \code{only_surnames = TRUE}.
#' For large corpora, e.g., German Drama Corpus or Russian Drama Corpus,
#' there is a problem of overplotting. You can plot only top authors by
#' parameters \code{top_n}, \code{top_minplays}, or \code{top_ratio}
#' adjustment.
#'
#' @param x \code{authors} object to plot.
#' @param only_surnames Logical, if \code{TRUE}, then only authors' surnames
#'   are shown, defaults to \code{FALSE}.
#' @param top_n Integer, number of top authors to show on plot.
#' @param top_minplays Integer, minimum number of plays for an author to be
#'   plotted.
#' @param top_ratio Numeric, from 0 to 1, maximum ratio of top authors to be
#'   plotted. For example, with \code{top_ratio = 0.1} maximum 10\% of top
#'   authors will be plotted.
#' @method plot authors
#' @export
plot.authors <- function(x,
                         only_surnames = FALSE,
                         top_n = nrow(x),
                         top_minplays = 1,
                         top_ratio = 1,
                         ...){
  N <- NULL #to pass check
  if(only_surnames){
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
