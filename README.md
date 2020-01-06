
<!-- README.md is generated from README.Rmd. Please edit that file -->
rdracor <img src="man/figures/logo.png" align="right" width="120" />
====================================================================

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/Pozdniakov/rdracor.svg?branch=master)](https://travis-ci.org/Pozdniakov/rdracor) <!-- badges: end -->

The goal of rdracor is to provide an R interface for the [Drama Corpora Project (Dracor) API](https://dracor.org/documentation/api). More on Dracor project [here](https://dracor.org).

Installation
------------

``` r
#install.packages("devtools") #if you don't have devtools installed
devtools::install_github("dracor-org/rdracor")
```

General info on corpora
-----------------------

This is a basic example which shows you how to solve a common problem:

``` r
library(rdracor)
get_dracor_api_info()## basic example code
#>         name status existdb version
#> 1 DraCor API   beta   4.7.0  0.59.0
```

``` r
corpora <- get_dracor()
summary(corpora)
#> There are 953 plays in 10 corpora    
corpora
#>                                   repository  name
#> 3    https://github.com/dracor-org/gerdracor   ger
#> 6    https://github.com/dracor-org/rusdracor   rus
#> 9    https://github.com/dracor-org/swedracor   swe
#> 2    https://github.com/dracor-org/caldracor   cal
#> 4  https://github.com/dracor-org/greekdracor greek
#> 7  https://github.com/dracor-org/shakedracor shake
#> 5    https://github.com/dracor-org/romdracor   rom
#> 8   https://github.com/dracor-org/spandracor  span
#> 10   https://github.com/dracor-org/tatdracor   tat
#> 1    https://github.com/dracor-org/alsdracor   als
#>                                     uri                    title
#> 3    https://dracor.org/api/corpora/ger      German Drama Corpus
#> 6    https://dracor.org/api/corpora/rus     Russian Drama Corpus
#> 9    https://dracor.org/api/corpora/swe     Swedish Drama Corpus
#> 2    https://dracor.org/api/corpora/cal    Calderón Drama Corpus
#> 4  https://dracor.org/api/corpora/greek       Greek Drama Corpus
#> 7  https://dracor.org/api/corpora/shake Shakespeare Drama Corpus
#> 5    https://dracor.org/api/corpora/rom       Roman Drama Corpus
#> 8   https://dracor.org/api/corpora/span     Spanish Drama Corpus
#> 10   https://dracor.org/api/corpora/tat       Tatar Drama Corpus
#> 1    https://dracor.org/api/corpora/als    Alsatian Drama Corpus
#>    characters female text male             updated     sp  stage plays
#> 3       11717   2411  480 8204 2020-01-06 10:29:36 339583 165134   480
#> 6        3636    858  210 2550 2019-12-10 17:33:53 117093  48493   210
#> 9         769    327   73  382 2019-09-08 00:34:42  35420  17209    68
#> 2         839    284   54  550 2019-12-21 18:10:41  23966   4758    54
#> 4         437    110   39  275 2019-12-10 16:44:54  15693     11    39
#> 7        1433      0   37    0 2019-06-23 23:40:19  31066  10450    37
#> 5         385    104   36  253 2019-12-10 09:46:11  18425    203    36
#> 8         580    226   25  331 2019-11-05 14:12:47  23600   8393    25
#> 10         30      9    3   20 2019-12-16 21:57:13    701    433     3
#> 1          16      8    1    8 2019-12-21 18:09:28   1334    211     1
#>    wordcount.text wordcount.sp wordcount.stage
#> 3         8646715      8252666         1047656
#> 6         2274917      2151978          208664
#> 9          737001       690633           96212
#> 2          568412       544039           27898
#> 4          321599       320968              20
#> 7          908286       876744           41230
#> 5          306144       291707             527
#> 8          444620       388883           84337
#> 10          13037        12223            1788
#> 1           36362        35959             719
plot(corpora)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

Plays in the corpus
-------------------

``` r
ru <- get_corpus(corpus = "rus")
head(ru)
#>          id                                name yearNormalized
#> 1 rus000001    turgenev-zavtrak-u-predvoditelja           1849
#> 2 rus000002          turgenev-vecher-v-sorrente           1852
#> 3 rus000003 turgenev-razgovor-na-bolshoj-doroge           1851
#> 4 rus000004              turgenev-provintsialka           1851
#> 5 rus000005             turgenev-neostorozhnost           1843
#> 6 rus000006                  turgenev-nahlebnik           1857
#>                        title                 subtitle      author.key
#> 1     Завтрак у предводителя                        – wikidata:Q42831
#> 2           Вечер в Сорренте                    Сцена wikidata:Q42831
#> 3 Разговор на большой дороге                    Сцена wikidata:Q42831
#> 4               Провинциалка Комедия в одном действии wikidata:Q42831
#> 5             Неосторожность                        – wikidata:Q42831
#> 6                  Нахлебник Комедия в двух действиях wikidata:Q42831
#>                author.name authors     source
#> 1 Тургенев, Иван Сергеевич    1, 2 Wikisource
#> 2 Тургенев, Иван Сергеевич    1, 2 Wikisource
#> 3 Тургенев, Иван Сергеевич    1, 2 Wikisource
#> 4 Тургенев, Иван Сергеевич    1, 2 Wikisource
#> 5 Тургенев, Иван Сергеевич    1, 2 Wikisource
#> 6 Тургенев, Иван Сергеевич    1, 2 Wikisource
#>                                                              sourceUrl
#> 1     https://ru.wikisource.org/wiki/Завтрак_у_предводителя_(Тургенев)
#> 2           https://ru.wikisource.org/wiki/Вечер_в_Сорренте_(Тургенев)
#> 3 https://ru.wikisource.org/wiki/Разговор_на_большой_дороге_(Тургенев)
#> 4               https://ru.wikisource.org/wiki/Провинциалка_(Тургенев)
#> 5             https://ru.wikisource.org/wiki/Неосторожность_(Тургенев)
#> 6                  https://ru.wikisource.org/wiki/Нахлебник_(Тургенев)
#>   printYear premiereYear writtenYear networkSize
#> 1      1856         1849        1849          11
#> 2      1888         1884        1852           7
#> 3      1851           NA          NA           3
#> 4      1851         1851        1850           7
#> 5      1843           NA        1843           6
#> 6      1857         1862        1848          14
#>                                                                             networkdataCsvUrl
#> 1    https://dracor.org/api/corpora/rus/play/turgenev-zavtrak-u-predvoditelja/networkdata/csv
#> 2          https://dracor.org/api/corpora/rus/play/turgenev-vecher-v-sorrente/networkdata/csv
#> 3 https://dracor.org/api/corpora/rus/play/turgenev-razgovor-na-bolshoj-doroge/networkdata/csv
#> 4              https://dracor.org/api/corpora/rus/play/turgenev-provintsialka/networkdata/csv
#> 5             https://dracor.org/api/corpora/rus/play/turgenev-neostorozhnost/networkdata/csv
#> 6                  https://dracor.org/api/corpora/rus/play/turgenev-nahlebnik/networkdata/csv
#>   wikidataId size  genre averageClustering numOfPersonGroups   density
#> 1  Q19164018   11 comedy         0.9185426                 0 0.8727273
#> 2  Q19140432    7   <NA>         0.5190476                 0 0.4761905
#> 3  Q19215006    3   <NA>         1.0000000                 0 1.0000000
#> 4   Q4659065    7 comedy         0.9238095                 0 0.8095238
#> 5   Q3204064    6   <NA>         0.7666667                 0 0.7333333
#> 6   Q3225142   14 comedy         1.0000000                 1 1.0000000
#>   averagePathLength               maxDegreeIds averageDegree diameter
#> 1          1.127273         several characters      8.727273        2
#> 2          1.619048                     avakov      2.857143        3
#> 3          1.000000 efrem|mihrjutkin|seliverst      2.000000        1
#> 4          1.190476   darja_ivanovna|stupendev      4.857143        2
#> 5          1.266667                  don_pablo      3.666667        2
#> 6          1.000000         several characters     13.000000        1
#>   yearPremiered yearPrinted maxDegree numOfSpeakers numConnectedComponents
#> 1          1849        1856        10            11                      1
#> 2          1884        1888         5             7                      1
#> 3            NA        1851         2             3                      1
#> 4          1851        1851         6             7                      1
#> 5            NA        1843         5             6                      1
#> 6          1862        1857        13            14                      1
#>   numOfSpeakersUnknown yearWritten numOfSpeakersFemale numOfSegments
#> 1                    0        1849                   1            11
#> 2                    0        1852                   2            15
#> 3                    0          NA                   0             1
#> 4                    0        1850                   2            25
#> 5                    0        1843                   2             4
#> 6                    1        1848                   4             2
#>   numOfSpeakersMale wikipediaLinkCount numOfActs
#> 1                10                  1         0
#> 2                 5                  0         0
#> 3                 3                  0         0
#> 4                 5                  1         0
#> 5                 4                  1         0
#> 6                 9                  4         2
#>                              playName
#> 1    turgenev-zavtrak-u-predvoditelja
#> 2          turgenev-vecher-v-sorrente
#> 3 turgenev-razgovor-na-bolshoj-doroge
#> 4              turgenev-provintsialka
#> 5             turgenev-neostorozhnost
#> 6                  turgenev-nahlebnik
summary(ru)
#> Written years (range): 1747 - 1940   
#> Premiere years (range): 1750 - 1992  
#> Years of the first printing (range): 1747 - 1986 
#> 210 plays in Russian Drama Corpus    
#> Corpus id: rus, repository: https://github.com/dracor-org/rusdracor
ru_au <- authors(ru)
head(ru_au)
#>                 key                             name  N
#> 1: wikidata:Q171976 Островский, Александр Николаевич 33
#> 2: wikidata:Q429915    Сумароков, Александр Петрович 14
#> 3:   wikidata:Q5685            Чехов, Антон Павлович 14
#> 4:    wikidata:Q835     Булгаков, Михаил Афанасьевич 10
#> 5:  wikidata:Q42831         Тургенев, Иван Сергеевич  9
#> 6: wikidata:Q191480           Крылов, Иван Андреевич  8
summary(ru_au)
#> There are 57 authors in Russian Drama Corpus 
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

Play network
------------

You can extract network for a specific play:

``` r
godunov <- get_play_igraph(corpus = "rus", 
                           play = "pushkin-boris-godunov")
```

This will create an object of S3 class `"play_igraph"` that inherits from `"igraph"`. It means that you can work with it as an `"igraph"` object:

``` r
library(igraph)
#> 
#> Attaching package: 'igraph'
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union
edge_density(godunov)
#> [1] 0.1061344
diameter(godunov)
#> [1] 7
graph.cohesion(godunov)
#> [1] 1
```

You can plot it: it will use plot method for `igraph` objects with some adjusted parameters. For example, vertices are coloured based on the gender and shape is based on whether a character is a group:

``` r
plot(godunov)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

Other commands
--------------

``` r
get_play_cast(corpus = "rus", 
              play = "pushkin-boris-godunov")
get_play_metadata(corpus = "rus", 
                  play = "pushkin-boris-godunov")
get_play_metrics(corpus = "rus", 
                 play = "pushkin-boris-godunov")
get_play_networkdata_csv(corpus = "rus", 
                         play = "pushkin-boris-godunov")
get_play_networkdata_gexf(corpus = "rus", 
                         play = "pushkin-boris-godunov")
get_play_rdf(corpus = "rus", 
             play = "pushkin-boris-godunov")
get_play_spoken_text(corpus = "rus", 
                     play = "pushkin-boris-godunov")
get_play_spoken_text_bych(corpus = "rus", 
                          play = "pushkin-boris-godunov")
get_play_stage_directions(corpus = "rus", 
                          play = "pushkin-boris-godunov")
get_play_stage_directions_with_sp(corpus = "rus", 
                                  play = "pushkin-boris-godunov")
get_play_tei(corpus = "rus", 
             play = "pushkin-boris-godunov")
```
