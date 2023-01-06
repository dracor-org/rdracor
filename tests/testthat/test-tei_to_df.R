test_that("tei_to_df converts tei object to tibble",
          {expect_s3_class(tei_to_df(get_text_tei(corpus = "rus", play = "gogol-zhenitba")),
            "tbl_df")
          })

test_that("get_text_df returns tibble",
          {expect_s3_class(get_text_df(corpus = "rus", play = "gogol-zhenitba"),
            "tbl_df")
          })
