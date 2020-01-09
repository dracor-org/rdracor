test_that("Russian corpus downloaded", {
  expect_equal(class(get_corpus("rus")), c("corpus", "data.frame"))
})

test_that("Russian corpus downloaded", {
  expect_s3_class(get_corpus("rus"), c("corpus", "data.frame"))
})

test_that("non-existant corpus returns error", {
  expect_error(get_corpus("non-existant"))
})
