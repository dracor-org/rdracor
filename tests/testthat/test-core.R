test_that("Numeric values induce error", {
  expect_error(form_play_request(1, 3), "corpus must be a single character value")
  expect_error(form_play_request("pushkin-boris-godunov", 3), "corpus must be")
  expect_error(form_play_request(1, "rus"), "play must be a single character value")
})

test_that("NULL values induce error", {
  expect_error(form_play_request(), "corpus must be")
  expect_error(form_play_request(corpus = "rus"), "play must be")
})

test_that("NA and empty strings induce error", {
  expect_error(form_play_request(NA_character_, "rus"), "play must be")
  expect_error(form_play_request("pushkin-boris-godunov", ""), "corpus must be")
})

test_that("More than one corpus induce error for a play", {
  expect_error(
    form_play_request("pushkin-boris-godunov", c("rus", "ger")),
    "corpus must be"
  )
})

test_that("requests identify the package in the User-Agent header", {
  ua <- dracor_user_agent()
  expect_s3_class(ua, "request")
  expect_match(ua$options$useragent, "^rdracor/[0-9.]+ \\(https://github.com/")
})

test_that("Valid request is created", {
  expect_equal(
    form_play_request(play = "pushkin-boris-godunov", corpus = "rus"),
    "https://dracor.org/api/v1/corpora/rus/plays/pushkin-boris-godunov"
  )
})

test_that("dracor_sparql() returns xml_document by default", {
  skip_if_no_dracor()
  expect_s3_class(
    dracor_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10"),
    "xml_document"
  )
})

test_that("dracor_sparql() returns character with parse = FALSE", {
  skip_if_no_dracor()
  expect_type(
    dracor_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10",
      parse = FALSE
    ),
    "character"
  )
})

test_that("dracor_api_info returns NULL", {
  skip_if_no_dracor()
  expect_invisible(dracor_api_info())
})

test_that("get_dracor_api_info returns https://dracor.org/api/v1", {
  expect_equal(get_dracor_api_url(), "https://dracor.org/api/v1")
})

test_that("set_dracor_api_url() validates the URL and removes a trailing slash", {
  old_url <- the$dracor_api_url
  on.exit(the$dracor_api_url <- old_url)
  expect_error(set_dracor_api_url(1), "single character")
  expect_error(set_dracor_api_url(c("a", "b")), "single character")
  suppressMessages(
    expect_output(
      set_dracor_api_url("http://127.0.0.1:9/api/v1/"),
      "was changed from"
    )
  )
  expect_equal(get_dracor_api_url(), "http://127.0.0.1:9/api/v1")
})

test_that("dracor_sparql() uses the host of the current 'DraCor' API URL", {
  expect_message(
    with_unavailable_dracor(dracor_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 1")),
    "127.0.0.1:9/fuseki/sparql"
  )
})
