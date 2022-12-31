test_that("API info is 1 x 4", {
  expect_equal(dim(get_dracor_api_info()), c(1, 4))
})

test_that("get_dracor_meta() returns dracor_meta object", {
  expect_s3_class(get_dracor_meta(), "dracor_meta")
})

test_that("is.dracor_meta() works for 'dracor_meta' object", {
  expect_true(is.dracor_meta(get_dracor_meta()))
})

test_that("is.dracor_meta() doesn't work for integer", {
  expect_false(is.dracor_meta(3L))
})

test_that("summary for dracor_meta object is visible", {
  corpora <- get_dracor_meta()
  summary_captured <- capture.output(summary(corpora))
  summary_length <- nchar(summary_captured)
  len_checks <-
    c(summary_length[1] > 0, summary_length[2] == 0, summary_length[3] > 0)
  expect_true(all(len_checks))
})
