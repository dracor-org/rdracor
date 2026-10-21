test_that("get_play_metadata returns list", {
  skip_if_no_dracor()
  expect_type(get_play_metadata("pushkin-boris-godunov", "rus"), "list")
})

test_that("rdf is not empty", {
  skip_if_no_dracor()
  tei <- get_play_rdf("pushkin-boris-godunov", "rus")
  text <- xml2::xml_text(tei)
  expect_gt(nchar(text), 0)
})

test_that("get_play_characters() returns characters with id, name and sex", {
  skip_if_no_dracor()
  characters <- get_play_characters("pushkin-boris-godunov", "rus")
  expect_gt(nrow(characters), 0)
  expect_true(all(c("id", "name", "sex") %in% names(characters)))
})
