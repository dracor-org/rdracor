test_that("API info is 1 x 4", {
  expect_equal(dim(get_dracor_api_info()), c(1, 4))
})
