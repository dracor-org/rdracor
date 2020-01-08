test_that("authors() works with corpus name", {
  expect_s3_class(authors("rus"), "authors")
})

test_that("authors() works with corpus object", {
  expect_s3_class(authors(get_corpus("shake")), "authors")
})

test_that("authors() returns error on dracor object", {
  expect_error(authors(get_dracor()))
})

test_that("summary for authors object is visible", {
  authors_ru <- authors("rus")
  expect_equal(length(capture.output(summary(authors_ru))), 8L)
})
