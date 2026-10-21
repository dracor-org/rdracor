# rdracor 1.1.0

* all functions that request 'DraCor' API now fail gracefully: if the API is
not available (no internet connection, the server is down or does not respond,
error status, data that cannot be parsed), they show an informative message
and return `NULL` instead of throwing an error
* added time limits for requests to 'DraCor' API: options
`rdracor.connect_timeout` (30 s) and `rdracor.timeout` (600 s), see
`?dracor_api`
* added `dracor_api_available()` to check whether 'DraCor' API is available
* fixed `dracor_api_info()` failing if 'DraCor' API is not available
* `get_dracor()` requests the list of corpora once instead of twice
* examples are run only if 'DraCor' API is available
* tests that need 'DraCor' API are not run on CRAN; added tests for the
behaviour of the functions without 'DraCor' API
* fixed `tei_to_df()` and `get_text_df()` losing the speaker (`who`) of verse
lines wrapped in `<lg>`; lines with several speakers keep all their ids;
`tei_to_df()` no longer modifies the document passed to it
* fixed `plot()` for `cooccur_igraph` and `relations_igraph` objects ignoring
igraph arguments passed by the user (e.g. `vertex.color`, `vertex.size`);
`gender_colors` can be given in any order; `edge_size_scale = NULL` works
* fixed `plot()` for `relations_igraph` objects not drawing vertices: colours
were taken from the character attribute `gender`, which 'DraCor' API v1.1.0
renamed to `sex` (dracor-org/dracor-api#319)
* `get_play_metadata(full_metadata = TRUE)` uses only the metadata columns
returned by the API and no longer returns `normalizedGenre` twice
* `set_dracor_api_url()` validates its argument and removes a trailing slash
* `dracor_sparql()` uses the host of the current 'DraCor' API URL
* argument validation errors (e.g. a missing play name) are no longer reported
as connection problems
* TLS certificates are verified for all requests
* fixed `citation("rdracor")`: full list of authors of the 'DraCor' paper and
DOI; added a citation for the package
* fixed typos in documentation; documented the format of `gender_colors`
* fixed `plot()` for `cooccur_igraph` objects failing or warning when a metric
is 0 for every character (e.g. betweenness in a two-character play) or the play
has no co-occurrences; unknown relation types are drawn in grey
* several authors of a play are separated with "; " in the attributes of
network objects
* `get_dracor()` downloads each corpus once even if its name is repeated and
no longer returns the duplicated column `yearNormalizedMeta`
* the `updated` column of `get_dracor_meta()` takes the UTC offset of 'DraCor'
API timestamps into account
* invalid `play` or `corpus` arguments give a clear error message
* requests to 'DraCor' API identify the package with a User-Agent header

# rdracor 1.0.6

* updated requests for all "gender" to "sex" properties with respect to recent 
'DraCor' API changes

# rdracor 1.0.5

* fixed bug with creating igraph objects with `get_net_*_igraph()` functions 
caused by 'DraCor' API changes

# rdracor 1.0.4

* updated deprecated functions imported from `{igraph}`
* Added progress bar to `get_dracor()`
* updated tests
* fixed bug with getting corpora with plays without authors (e.g., AmDraCor)
using `get_dracor()`

# rdracor 1.0.3

* updated the packaged to changes in 'Dracor' API
* updated tests
* removed cyrillic letters from example plots

# rdracor 0.7.7

* fixed `get_play_metadata()` not working with `full_metadata = TRUE` if
'DraCor' API URL was modified with `set_dracor_api_url()`

# rdracor 0.7.6

* Updated tests

# rdracor 0.7.5

* Fixed URL from ReadMe

# rdracor 0.7.4

* Fixed URL from ReadMe
* Added option to return simple igraph object for `get_net_*_igraph()` functions
* Added option to change 'DraCor' API URL

# rdracor 0.7.3

* Fixed error with outdated certificate 

# rdracor 0.7.2

* Fixed DESCRIPTION file
* Fixed spelling
* Updated `plot.dracor_meta()` function (fixed changing `par()` options)
* Added missing Rd-tags from documentation
* Updated Readme
* Updated parameters for `get_text_chr_*()` functions

# rdracor 0.7.1

* Changed hyphens to en-dash in `summary.dracor()`
* Updated Readme
* Fixed invalid URLs
* Deleted extra files
* Added donttest for examples with >5s
* Updated the package Title to title case

# rdracor 0.7.0

* Initial version of the package
