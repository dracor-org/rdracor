# rdracor 1.0.4

* updated deprecated functions importerd from `{igraph}`
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
>>>>>>> cba29901f42ade9ce755f800bd74cc22ac43ed72

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
