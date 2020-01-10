test_that("authors() works with corpus name", {
  expect_s3_class(authors("rus"), "authors")
})

test_that("authors() works with corpus object", {
  expect_s3_class(authors(get_corpus("shake")), "authors")
})

test_that("authors() returns error on dracor object", {
  expect_error(authors(get_dracor()))
})

test_that("is.authors() works", {
  authors_ru <- authors("rus")
  expect_true(is.authors(authors_ru))
})

test_that("summary for authors object is visible", {
  authors_ru <- authors("rus")
  expect_equal(length(capture.output(summary.authors(authors_ru))), 8L)
})

test_that("shortening names works", {
  expect_equal(shortening_names("Толстой, Лев"), "Толстой")
})

test_that("top_authors() return valid results for shake", {
  expect_equal(nchar(top_authors(authors("shake"))), 24)
})
