test_that("API info is 1 x 4", {
  expect_equal(dim(get_dracor_api_info()), c(1, 4))
})

test_that("get_dracor() returns dracor object", {
  expect_s3_class(get_dracor(), "dracor")
})

test_that("get_dracor() returns appropiate column names",
          {
            expected_names <-
              c(
                "repository",
                "name",
                "uri",
                "title",
                "characters",
                "female",
                "text",
                "male",
                "updated",
                "sp",
                "stage",
                "plays",
                "wordcount.text",
                "wordcount.sp",
                "wordcount.stage"
              )
            expect_equal(names(get_dracor()), expected_names)
          })

test_that("summary for dracor object is visible", {
  corpora <- get_dracor()
  summary_captured <- capture.output(summary(corpora))
  summary_length <- nchar(summary_captured)
  len_checks <-
    c(summary_length[1] > 0, summary_length[2] == 0, summary_length[3] > 0)
expect_true(all(len_checks))
})
