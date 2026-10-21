test_that("Cal corpus is S3 class 'dracor'", {
  skip_if_no_dracor()
  expect_s3_class(get_dracor("cal"), "dracor")
})

test_that("non-existant corpus returns error", {
  skip_if_no_dracor()
  expect_error(get_dracor("non-existant"))
})

test_that("several corpora are downloaded via get_dracor() if character vector
          is provided", {
  skip_if_no_dracor()
  expect_s3_class(get_dracor(c("tat", "span")), "tbl_df")
})

test_that("is.dracor() works for 'dracor' object", {
  skip_if_no_dracor()
  expect_true(is.dracor(get_dracor("cal")))
})

test_that("is.dracor() doesn't work for integer", {
  expect_false(is.dracor(list()))
})

test_that(
  "summary() work for 'dracor' object if there is no info on some years",
  {
    skip_if_no_dracor()
    expect_true(all(nchar(capture.output(
      summary(get_dracor("tat"))
    )) > 3L))
  }
)

test_that(
  "Written year with format 'YYYY/YYYY' is processed as integer in column
  yearWrittenFinish",
  {
    skip_if_no_dracor()
    expect_type(get_dracor("rus")$yearWrittenFinish, "integer")
  }
)

test_that("get_character_plays() for Maria Stuart returns at least 2 plays", {
  skip_if_no_dracor()
  expect_gte(nrow(get_character_plays(char_wiki_id = "Q131412")), 2L)
})
