test_that("Cal corpus is S3 class 'dracor'", {
  expect_s3_class(get_dracor("cal"), "dracor")
})

test_that("non-existant corpus returns error", {
  expect_error(get_dracor("non-existant"))
})

test_that("several corpora are downloaded via get_dracor() if character vector
          is provided",
          {
            expect_s3_class(get_dracor(c("tat", "span")), "tbl_df")
          })

test_that("is.dracor() works for 'dracor' object", {
  expect_true(is.dracor(get_dracor("cal")))
})

test_that("is.dracor() doesn't work for integer", {
  expect_false(is.dracor(list()))
})

test_that("summary() work for 'dracor' object if there is no info on some years", {
  expect_true(all(nchar(capture.output(
    summary(get_dracor("tat"))
  )) > 3))
})

test_that(
  "writtenYear with format 'YYYY/YYYY' is processed as integer in column writtenYearFinish",
  {
    expect_is(get_dracor("rus")$writtenYearFinish, "integer")
  }
)
