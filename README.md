
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rdracor <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/Pozdniakov/rdracor.svg?branch=master)](https://travis-ci.org/Pozdniakov/rdracor)
[![Codecov test
coverage](https://codecov.io/gh/Pozdniakov/rdracor/branch/master/graph/badge.svg)](https://codecov.io/gh/Pozdniakov/rdracor?branch=master)
<!-- badges: end -->

**Authors:** Ivan Pozdniakov, Frank Fischer<br /> **Licence:**
[GPL-3](https://opensource.org/licenses/GPL-3.0)

The goal of **rdracor** is to provide an R interface for the [DraCor
API](https://dracor.org/documentation/api) (DraCor: Drama Corpora
Project). Website of the project: [dracor.org](https://dracor.org).

## Installation

``` r
#install.packages("remotes") #if you don't have remotes installed
remotes::install_github("dracor-org/rdracor")
```

## General info on corpora

Retrieving general information about available corpora:

``` r
library(rdracor)
```

``` r
corpora <- get_dracor_meta()
summary(corpora)
#> DraCor hosts 11 corpora comprising 1130 plays.
#> 
#> The last updated corpus was German Drama Corpus (2020-12-14 17:52:20).
plot(corpora)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

## Plays in the corpus

``` r
ru <- get_dracor(corpus = "rus")
summary(ru)
#> 211 plays in Russian Drama Corpus    
#> Corpus id: rus, repository: https://github.com/dracor-org/rusdracor
#> Written years (range): 1747 - 1940   
#> Premiere years (range): 1750 - 1992  
#> Years of the first printing (range): 1747 - 1986
ru_au <- authors(ru)
summary(ru_au)
#> There are 58 authors in Russian Drama Corpus 
#> 
#> Top authors of the Corpus:   
#> 33 - Островский, Александр Николаевич    
#> 14 - Сумароков, Александр Петрович   
#> 14 - Чехов, Антон Павлович   
#> 10 - Булгаков, Михаил Афанасьевич    
#> 9 - Тургенев, Иван Сергеевич
plot(ru_au, top_minplays = 4)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

You can get all corpora at once:

``` r
all <- get_dracor()
summary(all)
#> 1132 plays in 11 corpora:    
#> Corpora id:  
#> ger (511 plays),rus (211 plays),ita (139 plays),swe (70 plays),cal (54 plays),greek (39 plays),shake (37 plays),rom (36 plays),span (25 plays),als (7 plays),tat (3 plays)
#> Written years (range): 43 - 1947 
#> Premiere years (range): -472 - 1992  
#> Years of the first printing (range): 1493 - 1986
```

## Play network

You can extract a network (undirected weighted graph) for a specific
play:

``` r
godunov <- play_igraph(corpus = "rus",
                       play = "pushkin-boris-godunov")
```

This will create an object of S3 class `"play_igraph"` that inherits
from `"igraph"`. It means that you can work with it as an `"igraph"`
object:

``` r
library(igraph)
edge_density(godunov)
#> [1] 0.1061344
diameter(godunov, weights = NA)
#> [1] 6
graph.cohesion(godunov)
#> [1] 1
```

You can plot the graph: `plot()` will use plot method for `igraph`
objects with some adjusted parameters. For example, vertices are
coloured based on the gender and shape is based on whether a character
is a group:

``` r
plot(godunov)
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

In addition, you can get a summary with network properties and gender
distribution:

``` r
summary(godunov)
#> rus: pushkin-boris-godunov - network summary 
#>  
#>          Size: 79 (9 FEMALES, 69 MALES, 1 UNKNOWN)   
#>       Density: 0.11  
#>        Degree:   
#>          - Maximum: 29 (Борис)   
#>      Distance:   
#>          - Maximum (Diameter): 7 
#>          - Average: 3.03 
#>    Clustering:   
#>          - Global: 0.65  
#>          - Average local: 0.92   
#>      Cohesion: 1 
#> Assortativity: -0.06
```
