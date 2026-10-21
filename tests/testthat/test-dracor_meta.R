test_that("get_dracor_meta() returns dracor_meta object", {
  skip_if_no_dracor()
  expect_s3_class(get_dracor_meta(), "dracor_meta")
})

test_that("is.dracor_meta() works for 'dracor_meta' object", {
  skip_if_no_dracor()
  expect_true(is.dracor_meta(get_dracor_meta()))
})

test_that("is.dracor_meta() doesn't work for integer", {
  expect_false(is.dracor_meta(3L))
})

test_that("parse_dracor_datetime() takes the UTC offset into account", {
  parsed <- parse_dracor_datetime(c(
    "2026-10-07T03:32:39.834+02:00",
    "2026-10-07T03:32:39Z",
    "2026-10-07T03:32:39",
    NA
  ))
  expect_s3_class(parsed, "POSIXct")
  expect_equal(
    format(parsed[1:3], "%Y-%m-%d %H:%M:%S", tz = "UTC"),
    c("2026-10-07 01:32:39", "2026-10-07 03:32:39", "2026-10-07 03:32:39")
  )
  expect_true(is.na(parsed[4]))
})

test_that("plot() for dracor_meta object works", {
  skip_if_no_dracor()
  pdf(NULL)
  expect_silent(plot(get_dracor_meta()))
  dev.off()
})

test_that("summary for dracor_meta object is visible", {
  skip_if_no_dracor()
  corpora <- get_dracor_meta()
  summary_captured <- capture.output(summary(corpora))
  summary_length <- nchar(summary_captured)
  len_checks <-
    c(summary_length[1] > 0, summary_length[2] == 0, summary_length[3] > 0)
  expect_true(all(len_checks))
})
