test_that("tei text is not empty", {
  tei <- get_text_tei("pushkin-boris-godunov", "rus")
  text <- xml2::xml_text(tei)
  expect_gt(nchar(text), 0)
})

test_that("get_text_chr_spoken() returns text", {
  expect_type(
    get_text_chr_spoken("pushkin-boris-godunov", "rus"),
    "character"
  )
})

test_that("get_text_chr_spoken() for Boris Godunov, UNKNOWN gender returns more than one value", {
  expect_gt(
    length(
      get_text_chr_spoken("pushkin-boris-godunov", "rus", "UNKNOWN")
    ),
    1
  )
})

test_that("get_text_chr_spoken_bych() returns data.frame", {
  expect_type(
    get_text_chr_spoken_bych("pushkin-boris-godunov", "rus"),
    "list"
  )
})

test_that("get_text_chr_stage() returns text", {
  expect_type(
    get_text_chr_stage("pushkin-boris-godunov", "rus"),
    "character"
  )
})

test_that("get_text_chr_stage_with_sp() returns text", {
  expect_type(
    get_text_chr_stage_with_sp("pushkin-boris-godunov", "rus"),
    "character"
  )
})
