test_that("Numeric values induce error", {
  expect_error(form_play_request(1, 3))
})

test_that("NULL values induce error", {
  expect_error(form_play_request())
})

test_that("More than one corpus induce error for a play", {
  expect_error(form_play_request("pushkin-boris-godunov", c("rus", "ger")))
})

test_that("Valid request is created", {
  expect_equal(form_play_request(play = "pushkin-boris-godunov", corpus = "rus"),
               "https://dracor.org/api/corpora/rus/play/pushkin-boris-godunov")
})
