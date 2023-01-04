test_that("get_play_metadata returns list", {
  expect_type(get_play_metadata("pushkin-boris-godunov", "rus"), "list")
})

test_that("get_play_metrics returns list", {
  expect_type(get_play_metrics("pushkin-boris-godunov", "rus"), "list")
})

test_that("tei text is not empty", {
  tei <- get_play_tei("pushkin-boris-godunov", "rus")
  text <- xml2::xml_text(tei)
  expect_gt(nchar(text), 0)
})

test_that("rdf text is not empty", {
  tei <- get_play_rdf("pushkin-boris-godunov", "rus")
  text <- xml2::xml_text(tei)
  expect_gt(nchar(text), 0)
})

test_that("boris godunov cast has 79 characters", {
  expect_equal(nrow(get_play_cast("pushkin-boris-godunov", "rus")), 79)
})

test_that("column names for get_play_networkdata_csv() are valid", {
  expect_equal(
    names(get_play_networkdata_csv("pushkin-boris-godunov", "rus")),
    c("Source", "Type", "Target", "Weight")
  )
})

test_that("get_play_networkdata_gexf() returns valid object", {
  gexf <- get_play_networkdata_gexf("pushkin-boris-godunov", "rus")
  expect_equal(
    as.character(xml2::xml_contents(
      xml2::xml_contents(xml2::xml_children(gexf)[1])[1]
    )),
    "dracor.org"
  )
})

test_that("get_play_spoken_text() returns text", {
  expect_type(
    get_play_spoken_text("pushkin-boris-godunov", "rus"),
    "character"
  )
})

test_that("get_play_spoken_text() for Boris Godunov, UNKNOWN gender returns more than one value", {
  expect_gt(
    length(
      get_play_spoken_text("pushkin-boris-godunov", "rus", "UNKNOWN")
    ),
    1
  )
})

test_that("get_play_spoken_text_bych() returns data.frame", {
  expect_type(
    get_play_spoken_text_bych("pushkin-boris-godunov", "rus"),
    "list"
  )
})

test_that("get_play_stage_directions() returns text", {
  expect_type(
    get_play_stage_directions("pushkin-boris-godunov", "rus"),
    "character"
  )
})

test_that("get_play_stage_directions_with_sp() returns text", {
  expect_type(
    get_play_stage_directions_with_sp("pushkin-boris-godunov", "rus"),
    "character"
  )
})

test_that("get_sparql() returns xml_document", {
  expect_s3_class(get_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10"), "xml_document")
})

test_that("get_sparql() with parse = FALSE returns character", {
  expect_type(get_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10", parse = FALSE), "character")
})

test_that("play_igraph is returned by play_igraph()", {
  expect_s3_class(play_igraph("gogol-zhenitba", "rus"), "play_igraph")
})

test_that("label_play_igraph() return come NA for big network", {
  henryiv <- play_igraph("henry-iv-part-i", "shake")
  expect_true(any(is.na(label_play_igraph(henryiv))))
})

test_that("label_play_igraph() do not return NA after max_graph_size adjustment", {
  henryiv <- play_igraph("henry-iv-part-i", "shake")
  expect_true(all(!is.na(label_play_igraph(henryiv, max_graph_size = 36))))
})

test_that("summary.play_igraph() prints appropriate number of rows", {
  henryiv <- play_igraph("henry-iv-part-i", "shake")
  expect_equal(length(capture.output(summary(henryiv))), 14L)
})
