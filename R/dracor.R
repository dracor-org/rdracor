#' @importFrom jsonlite fromJSON
#' @export
get_dracor_api_info <- function() {
  as.data.frame(dracor_api("https://dracor.org/api/info", expected_format = "application/json"))
}

#' @exportClass dracor
#' @export
dracor <- function(dracor_df){
  dracor <- type.convert(dracor_df, as.is = TRUE)
  names(dracor) <- gsub("metrics.", "", names(dracor), fixed = TRUE)
  dracor$updated <- as.POSIXct(dracor$updated, format = "%FT%H:%M:%OS", tz = "UTC")
  dracor <- dracor[order(-dracor$plays),]
  attributes(dracor) <- c(attributes(dracor),
                          get_dracor_api_info())
  class(dracor) <- c("dracor", class(dracor))
  return(dracor)
}

is.dracor <- function(x) {
  inherits(x, "dracor")
}

#' @export
get_dracor <- function() dracor(dracor_api("https://dracor.org/api/corpora?include=metrics",
                                           expected_format = "application/json", flatten = TRUE))

#' @method summary dracor
#' @export
summary.dracor <- function(object, ...){
  n_plays <- sum(object$plays)
  n_corpora <- nrow(object)
  last_upd <- which.max(object$updated)
  cat(sprintf("There are %d plays in %d corpora", n_plays, n_corpora),
      sprintf("The last update was %s for %s", object$updated[last_upd], object$corpus.title[last_upd]),
      sep = "\t\n\n")
}

#' @method plot dracor
#' @export
plot.dracor <- function(x, pch = 16, col = "black",
                        lty.lolly = 1, lty.baseline = 2, cex = 0.8,
                        left_margin = 10.5, ...) {
  y_in <- rev(1:nrow(x))
  old.par <- par(no.readonly = TRUE)
  par(mar=c(3,left_margin,4,2)+0.1, mgp = c(2,1,0))
  plot.default(x$plays, y_in, pch = pch,
               main = "Number of plays for each corpus",
               cex.main = 1,
               xlab = "Plays",
               ylab = NA,
               xlim = c(-20, max(x$plays)*1.2),
               yaxt = "n",
               col = col,
               lty = lty.lolly,
               ...)
  axis(2, at=y_in,labels=x$title, las = 1, cex.axis = cex)
  abline(v = 0, lty = lty.baseline)
  segments(0, y_in, x$plays, y_in, col = col)
  text(x$plays+0.1*max(x$plays), y_in, labels = x$plays, col = col, cex = cex)
  par(old.par)
}


