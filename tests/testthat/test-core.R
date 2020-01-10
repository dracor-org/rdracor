test_that("numeric values induce error", {
  expect_error(form_play_request(1, 3))
})

test_that("NULL values induce error", {
  expect_error(form_play_request())
})

test_that("NULL values induce error", {
  expect_error(form_play_request(c("rus", "ger"), "pushkin-boris-godunov"))
})
