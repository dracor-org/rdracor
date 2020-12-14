test_that("Russian corpus downloaded", {
  expect_equal(class(get_dracor("rus")), c("dracor", "data.frame"))
})

test_that("Russian corpus downloaded", {
  expect_s3_class(get_dracor("rus"), c("dracor", "data.frame"))
})

test_that("non-existant corpus returns error", {
  expect_error(get_dracor("non-existant"))
})

test_that("is.dracor() works", {
  expect_true(is.dracor(get_dracor("cal")))
})

test_that("is.dracor() works", {
  expect_false(is.dracor(3))
})

test_that("summary() work for 'dracor' object if there is no info on years", {
  expect_true(all(nchar(capture.output(summary(get_dracor("tat")))) > 3))
})

test_that("writtenYear with format 'YYYY/YYYY' is processed as integer in column writtenYearFinish",{
  expect_is(get_dracor("rus")$writtenYearFinish, "integer")
})
