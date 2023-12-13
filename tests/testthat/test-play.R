test_that("get_play_metadata returns list", {
  expect_type(get_play_metadata("pushkin-boris-godunov", "rus"), "list")
})

test_that("rdf is not empty", {
  tei <- get_play_rdf("pushkin-boris-godunov", "rus")
  text <- xml2::xml_text(tei)
  expect_gt(nchar(text), 0)
})

test_that("boris godunov has 79 characters", {
  expect_equal(nrow(get_play_characters("pushkin-boris-godunov", "rus")), 79)
})
