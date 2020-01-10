test_that("Russian corpus downloaded", {
  expect_equal(class(get_corpus("rus")), c("corpus", "data.frame"))
})

test_that("Russian corpus downloaded", {
  expect_s3_class(get_corpus("rus"), c("corpus", "data.frame"))
})

test_that("non-existant corpus returns error", {
  expect_error(get_corpus("non-existant"))
})

test_that("is.corpus() works", {
  expect_true(is.corpus(get_corpus("cal")))
})

test_that("is.corpus() works", {
  expect_false(is.corpus(3))
})

test_that("summary() work for 'corpus' object if there is no info on years", {
  expect_true(all(nchar(capture.output(summary(get_corpus("tat"))))>3))
})


