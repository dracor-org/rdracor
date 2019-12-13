
<!-- README.md is generated from README.Rmd. Please edit that file -->
rdracor <img src="man/figures/logo.png" align="right" width="120" />
====================================================================

<!-- badges: start -->
<!-- badges: end -->
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
#> $name
#> [1] "DraCor API"
#> 
#> $status
#> [1] "beta"
#> 
#> $existdb
#> [1] "4.7.0"
#> 
#> $version
#> [1] "0.59.0"
```

``` r
corpora <- get_dracor()
summary(corpora)
#>   repository            name               uri           
#>  Length:9           Length:9           Length:9          
#>  Class :character   Class :character   Class :character  
#>  Mode  :character   Mode  :character   Mode  :character  
#>                                                          
#>                                                          
#>                                                          
#>     title             characters        female            text      
#>  Length:9           Min.   :   16   Min.   :   0.0   Min.   :  1.0  
#>  Class :character   1st Qu.:  437   1st Qu.: 104.0   1st Qu.: 36.0  
#>  Mode  :character   Median :  769   Median : 226.0   Median : 39.0  
#>                     Mean   : 2092   Mean   : 468.7   Mean   :105.4  
#>                     3rd Qu.: 1433   3rd Qu.: 327.0   3rd Qu.: 73.0  
#>                     Max.   :10734   Max.   :2301.0   Max.   :474.0  
#>       male         updated                          sp        
#>  Min.   :   0   Min.   :2019-06-23 23:40:19   Min.   :  1334  
#>  1st Qu.: 253   1st Qu.:2019-09-28 11:31:40   1st Qu.: 18425  
#>  Median : 331   Median :2019-12-07 18:27:03   Median : 23966  
#>  Mean   :1302   Mean   :2019-10-30 01:12:45   Mean   : 66311  
#>  3rd Qu.: 550   3rd Qu.:2019-12-10 16:44:54   3rd Qu.: 35420  
#>  Max.   :7365   Max.   :2019-12-10 18:23:17   Max.   :330206  
#>      stage            plays       wordcount.text     wordcount.sp    
#>  Min.   :    11   Min.   :  1.0   Min.   :  36362   Min.   :  35959  
#>  1st Qu.:   211   1st Qu.: 36.0   1st Qu.: 321599   1st Qu.: 320968  
#>  Median :  8393   Median : 39.0   Median : 568412   Median : 544039  
#>  Mean   : 27823   Mean   :104.9   Mean   :1548915   Mean   :1474106  
#>  3rd Qu.: 17209   3rd Qu.: 68.0   3rd Qu.: 908286   3rd Qu.: 876744  
#>  Max.   :160681   Max.   :474.0   Max.   :8342891   Max.   :7966041  
#>  wordcount.stage  
#>  Min.   :     20  
#>  1st Qu.:    719  
#>  Median :  41230  
#>  Mean   : 163972  
#>  3rd Qu.:  96212  
#>  Max.   :1016145
corpora
#>                                  repository  name
#> 3   https://github.com/dracor-org/gerdracor   ger
#> 6   https://github.com/dracor-org/rusdracor   rus
#> 9   https://github.com/dracor-org/swedracor   swe
#> 2   https://github.com/dracor-org/caldracor   cal
#> 4 https://github.com/dracor-org/greekdracor greek
#> 7 https://github.com/dracor-org/shakedracor shake
#> 5   https://github.com/dracor-org/romdracor   rom
#> 8  https://github.com/dracor-org/spandracor  span
#> 1   https://github.com/dracor-org/alsdracor   als
#>                                    uri                    title characters
#> 3   https://dracor.org/api/corpora/ger      German Drama Corpus      10734
#> 6   https://dracor.org/api/corpora/rus     Russian Drama Corpus       3636
#> 9   https://dracor.org/api/corpora/swe     Swedish Drama Corpus        769
#> 2   https://dracor.org/api/corpora/cal    Calderón Drama Corpus        839
#> 4 https://dracor.org/api/corpora/greek       Greek Drama Corpus        437
#> 7 https://dracor.org/api/corpora/shake Shakespeare Drama Corpus       1433
#> 5   https://dracor.org/api/corpora/rom       Roman Drama Corpus        385
#> 8  https://dracor.org/api/corpora/span     Spanish Drama Corpus        580
#> 1   https://dracor.org/api/corpora/als    Alsatian Drama Corpus         16
#>   female text male             updated     sp  stage plays wordcount.text
#> 3   2301  474 7365 2019-12-10 18:23:17 330206 160681   474        8342891
#> 6    858  210 2550 2019-12-10 17:33:53 117093  48493   210        2274917
#> 9    327   73  382 2019-09-08 00:34:42  35420  17209    68         737001
#> 2    284   54  550 2019-09-28 11:31:40  23966   4758    54         568412
#> 4    110   39  275 2019-12-10 16:44:54  15693     11    39         321599
#> 7      0   37    0 2019-06-23 23:40:19  31066  10450    37         908286
#> 5    104   36  253 2019-12-10 09:46:11  18425    203    36         306144
#> 8    226   25  331 2019-11-05 14:12:47  23600   8393    25         444620
#> 1      8    1    8 2019-12-07 18:27:03   1334    211     1          36362
#>   wordcount.sp wordcount.stage
#> 3      7966041         1016145
#> 6      2151978          208664
#> 9       690633           96212
#> 2       544039           27898
#> 4       320968              20
#> 7       876744           41230
#> 5       291707             527
#> 8       388883           84337
#> 1        35959             719
```

Plays in the corpus
-------------------

``` r
ru <- get_corpus("rus")
head(ru)
#>          id                                name yearNormalized
#> 1 rus000001    turgenev-zavtrak-u-predvoditelja           1849
#> 2 rus000002          turgenev-vecher-v-sorrente           1852
#> 3 rus000003 turgenev-razgovor-na-bolshoj-doroge           1851
#> 4 rus000004              turgenev-provintsialka           1851
#> 5 rus000005             turgenev-neostorozhnost           1843
#> 6 rus000006                  turgenev-nahlebnik           1857
#>                        title                 subtitle authors     source
#> 1     Завтрак у предводителя                        –    1, 2 Wikisource
#> 2           Вечер в Сорренте                    Сцена    1, 2 Wikisource
#> 3 Разговор на большой дороге                    Сцена    1, 2 Wikisource
#> 4               Провинциалка Комедия в одном действии    1, 2 Wikisource
#> 5             Неосторожность                        –    1, 2 Wikisource
#> 6                  Нахлебник Комедия в двух действиях    1, 2 Wikisource
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
#>   wikidataId      author.key              author.name size  genre
#> 1  Q19164018 wikidata:Q42831 Тургенев, Иван Сергеевич   11 comedy
#> 2  Q19140432 wikidata:Q42831 Тургенев, Иван Сергеевич    7   <NA>
#> 3  Q19215006 wikidata:Q42831 Тургенев, Иван Сергеевич    3   <NA>
#> 4   Q4659065 wikidata:Q42831 Тургенев, Иван Сергеевич    7 comedy
#> 5   Q3204064 wikidata:Q42831 Тургенев, Иван Сергеевич    6   <NA>
#> 6   Q3225142 wikidata:Q42831 Тургенев, Иван Сергеевич   14 comedy
#>   averageClustering numOfPersonGroups   density averagePathLength
#> 1         0.9185426                 0 0.8727273          1.127273
#> 2         0.5190476                 0 0.4761905          1.619048
#> 3         1.0000000                 0 1.0000000          1.000000
#> 4         0.9238095                 0 0.8095238          1.190476
#> 5         0.7666667                 0 0.7333333          1.266667
#> 6         1.0000000                 1 1.0000000          1.000000
#>                 maxDegreeIds averageDegree diameter yearPremiered
#> 1         several characters      8.727273        2          1849
#> 2                     avakov      2.857143        3          1884
#> 3 efrem|mihrjutkin|seliverst      2.000000        1            NA
#> 4   darja_ivanovna|stupendev      4.857143        2          1851
#> 5                  don_pablo      3.666667        2            NA
#> 6         several characters     13.000000        1          1862
#>   yearPrinted maxDegree numOfSpeakers numConnectedComponents
#> 1        1856        10            11                      1
#> 2        1888         5             7                      1
#> 3        1851         2             3                      1
#> 4        1851         6             7                      1
#> 5        1843         5             6                      1
#> 6        1857        13            14                      1
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
#>          id                       name     yearNormalized        title    
#>  rus000001:  1   afinogenov-mashenka:  1   Min.   :1747   Агриопа   :  1  
#>  rus000002:  1   andreyev-k-zvezdam :  1   1st Qu.:1811   Адам и Ева:  1  
#>  rus000003:  1   andreyev-mysl      :  1   Median :1852   Актеон    :  1  
#>  rus000004:  1   andreyev-ne-ubiy   :  1   Mean   :1848   Актер     :  1  
#>  rus000005:  1   babel-marija       :  1   3rd Qu.:1886   Американцы:  1  
#>  rus000006:  1   babel-zakat        :  1   Max.   :1947   Антигона  :  1  
#>  (Other)  :204   (Other)            :204                  (Other)   :204  
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                                                                           
#>                      subtitle  
#>  –                       : 32  
#>  Комедия в пяти действиях: 15  
#>  Комедия в трех действиях: 10  
#>  Комедия                 :  9  
#>  Трагедия                :  9  
#>  (Other)                 :134  
#>  NA's                    :  1  
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>                                
#>  authors.Length  authors.Class  authors.Mode
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>  2           data.frame  list               
#>                                           source   
#>  Библиотека Максима Мошкова (lib.ru)         :100  
#>  Интернет-библиотека Алексея Комарова        : 41  
#>  Wikisource                                  : 34  
#>  Русская виртуальная библиотека (rvb.ru)     : 28  
#>  Фундаментальная электронная библиотека (ФЭБ):  2  
#>  Wikilivres/Bibliowiki                       :  2  
#>  (Other)                                     :  3  
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                    
#>                                                               sourceUrl  
#>  http://az.lib.ru/a/andreew_l_n/text_1010.shtml                    :  1  
#>  http://az.lib.ru/a/andreew_l_n/text_1290.shtml                    :  1  
#>  http://az.lib.ru/a/andreew_l_n/text_1330.shtml                    :  1  
#>  http://az.lib.ru/b/belxskij_w_i/text_1903_skazanie_o_kitezhe.shtml:  1  
#>  http://az.lib.ru/b/blok_a_a/text_0100.shtml                       :  1  
#>  http://az.lib.ru/b/blok_a_a/text_0190.shtml                       :  1  
#>  (Other)                                                           :204  
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>    printYear     premiereYear   writtenYear    networkSize    
#>  Min.   :1747   Min.   :1750   Min.   :1747   Min.   :  2.00  
#>  1st Qu.:1818   1st Qu.:1818   1st Qu.:1825   1st Qu.:  8.00  
#>  Median :1856   Median :1861   Median :1856   Median : 11.00  
#>  Mean   :1854   Mean   :1855   Mean   :1852   Mean   : 17.31  
#>  3rd Qu.:1888   3rd Qu.:1890   3rd Qu.:1889   3rd Qu.: 18.00  
#>  Max.   :1986   Max.   :1992   Max.   :1940   Max.   :102.00  
#>  NA's   :13     NA's   :52     NA's   :44                     
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                               
#>                                                                    networkdataCsvUrl
#>  https://dracor.org/api/corpora/rus/play/afinogenov-mashenka/networkdata/csv:  1    
#>  https://dracor.org/api/corpora/rus/play/andreyev-k-zvezdam/networkdata/csv :  1    
#>  https://dracor.org/api/corpora/rus/play/andreyev-mysl/networkdata/csv      :  1    
#>  https://dracor.org/api/corpora/rus/play/andreyev-ne-ubiy/networkdata/csv   :  1    
#>  https://dracor.org/api/corpora/rus/play/babel-marija/networkdata/csv       :  1    
#>  https://dracor.org/api/corpora/rus/play/babel-zakat/networkdata/csv        :  1    
#>  (Other)                                                                    :204    
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>                                                                                     
#>      wikidataId             author.key 
#>  Q1038931 :  1   wikidata:Q171976: 33  
#>  Q1075072 :  1   wikidata:Q429915: 14  
#>  Q1192719 :  1   wikidata:Q5685  : 14  
#>  Q1194195 :  1   wikidata:Q835   : 10  
#>  Q1214669 :  1   wikidata:Q42831 :  9  
#>  Q12756876:  1   wikidata:Q191480:  8  
#>  (Other)  :204   (Other)         :122  
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                                        
#>                            author.name       size             genre   
#>  Островский, Александр Николаевич: 37   Min.   :  2.00   comedy  :87  
#>  Сумароков, Александр Петрович   : 14   1st Qu.:  8.00   drama   :16  
#>  Чехов, Антон Павлович           : 14   Median : 11.00   pictures: 2  
#>  Булгаков, Михаил Афанасьевич    : 10   Mean   : 17.31   scenes  : 1  
#>  Тургенев, Иван Сергеевич        :  9   3rd Qu.: 18.00   tragedy :27  
#>  Гоголь, Николай Васильевич      :  8   Max.   :102.00   NA's    :77  
#>  (Other)                         :118                                 
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>                                                                       
#>  averageClustering numOfPersonGroups    density        averagePathLength
#>  Min.   :0.0000    Min.   : 0.0000   Min.   :0.04444   Min.   :1.000    
#>  1st Qu.:0.7996    1st Qu.: 0.0000   1st Qu.:0.42833   1st Qu.:1.135    
#>  Median :0.8592    Median : 0.0000   Median :0.65336   Median :1.339    
#>  Mean   :0.8316    Mean   : 0.9095   Mean   :0.64130   Mean   :1.399    
#>  3rd Qu.:0.9238    3rd Qu.: 0.0000   3rd Qu.:0.85649   3rd Qu.:1.612    
#>  Max.   :1.0000    Max.   :19.0000   Max.   :1.00000   Max.   :3.027    
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>                                                                         
#>              maxDegreeIds averageDegree       diameter     yearPremiered 
#>  several characters: 54   Min.   : 0.400   Min.   :1.000   Min.   :1750  
#>  dimitrij          :  2   1st Qu.: 4.571   1st Qu.:2.000   1st Qu.:1818  
#>  agriopa           :  1   Median : 6.400   Median :2.000   Median :1861  
#>  aksjusha          :  1   Mean   : 7.613   Mean   :2.381   Mean   :1855  
#>  Akteon            :  1   3rd Qu.: 9.000   3rd Qu.:3.000   3rd Qu.:1890  
#>  Alber             :  1   Max.   :35.049   Max.   :6.000   Max.   :1992  
#>  (Other)           :150                                    NA's   :52    
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>   yearPrinted     maxDegree     numOfSpeakers    numConnectedComponents
#>  Min.   :1747   Min.   : 1.00   Min.   :  2.00   Min.   : 1.000        
#>  1st Qu.:1818   1st Qu.: 6.00   1st Qu.:  8.00   1st Qu.: 1.000        
#>  Median :1856   Median : 9.50   Median : 11.00   Median : 1.000        
#>  Mean   :1854   Mean   :13.09   Mean   : 17.31   Mean   : 1.281        
#>  3rd Qu.:1888   3rd Qu.:15.00   3rd Qu.: 18.00   3rd Qu.: 1.000        
#>  Max.   :1986   Max.   :79.00   Max.   :102.00   Max.   :30.000        
#>  NA's   :13                                                            
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>                                                                        
#>  numOfSpeakersUnknown  yearWritten   numOfSpeakersFemale numOfSegments   
#>  Min.   : 0.000       Min.   :1747   Min.   : 0.000      Min.   :  1.00  
#>  1st Qu.: 0.000       1st Qu.:1825   1st Qu.: 2.000      1st Qu.:  9.00  
#>  Median : 0.000       Median :1856   Median : 3.000      Median : 23.00  
#>  Mean   : 1.086       Mean   :1852   Mean   : 4.086      Mean   : 25.01  
#>  3rd Qu.: 0.000       3rd Qu.:1889   3rd Qu.: 5.000      3rd Qu.: 36.00  
#>  Max.   :29.000       Max.   :1940   Max.   :17.000      Max.   :100.00  
#>                       NA's   :44                                         
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>                                                                          
#>  numOfSpeakersMale wikipediaLinkCount   numOfActs    
#>  Min.   : 1.00     Min.   : 0.000     Min.   :0.000  
#>  1st Qu.: 5.00     1st Qu.: 0.000     1st Qu.:0.000  
#>  Median : 7.00     Median : 0.000     Median :3.000  
#>  Mean   :12.14     Mean   : 2.405     Mean   :2.738  
#>  3rd Qu.:12.00     3rd Qu.: 2.750     3rd Qu.:5.000  
#>  Max.   :88.00     Max.   :35.000     Max.   :6.000  
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                                                      
#>                 playName  
#>  afinogenov-mashenka:  1  
#>  andreyev-k-zvezdam :  1  
#>  andreyev-mysl      :  1  
#>  andreyev-ne-ubiy   :  1  
#>  babel-marija       :  1  
#>  babel-zakat        :  1  
#>  (Other)            :204  
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#>                           
#> 
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

This will create an object of S3 class `"play_igraph"` that is heritated from `"igraph"`. It means that you can work with it as an `"igraph"` object:

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

You can plot it, the default parameters are adjusted to the specific of the corpus. For examples, vertices are coloured based on the gender and shape is based on whether a character is a group:

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
