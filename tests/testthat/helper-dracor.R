# Tests that need 'DraCor' API are never run on CRAN and are skipped locally
# if the API is not available. The availability check is made at most once per
# test run.
dracor_available <- local({
  result <- NULL
  function() {
    if (is.null(result)) result <<- dracor_api_available()
    result
  }
})

skip_if_no_dracor <- function() {
  skip_on_cran()
  skip_if_not(dracor_available(), "'DraCor' API is not available")
}

# Nothing listens on port 9 (discard) of localhost, so every request fails
# immediately without going to the internet
with_unavailable_dracor <- function(code) {
  old_url <- the$dracor_api_url
  the$dracor_api_url <- "http://127.0.0.1:9/api/v1"
  on.exit(the$dracor_api_url <- old_url)
  force(code)
}
