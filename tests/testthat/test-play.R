

test_that("length of the list returned by get_play_metadata is 19", {
  expect_equal(length(get_play_metadata("rus", "pushkin-boris-godunov")), 19)
})

test_that("length of the list returned by get_play_metrics is 14", {
  expect_equal(length(get_play_metrics("rus", "pushkin-boris-godunov")), 14)
})

test_that("tei text is not empty", {
  tei <- get_play_tei("rus", "pushkin-boris-godunov")
  text <- xml2::xml_text(tei)
  expect_gt(nchar(text), 0)
})

test_that("rdf text is not empty", {
  tei <- get_play_rdf("rus", "pushkin-boris-godunov")
  text <- xml2::xml_text(tei)
  expect_gt(nchar(text), 0)
})

test_that("boris godunov cast has 12 columns and 79 characters", {
  expect_equal(dim(get_play_cast("rus", "pushkin-boris-godunov")), c(79, 12))
})

test_that("column names for get_play_networkdata_csv() are valid", {
  expect_equal(names(get_play_networkdata_csv("rus", "pushkin-boris-godunov")),
               c("Source", "Type", "Target", "Weight"))
})

test_that("get_play_networkdata_gexf() returns valid object", {
  gexf = get_play_networkdata_gexf("rus", "pushkin-boris-godunov")
  expect_equal(as.character(xml2::xml_contents(
    xml2::xml_contents(xml2::xml_children(gexf)[1])[1]
  )),
  "dracor.org")
})

test_that("get_play_spoken_text() returns text", {
  expect_type(get_play_spoken_text("rus", "pushkin-boris-godunov"),
              "character")
})

test_that("get_play_spoken_text() for Boris Godunov, UNKNOWN gender returns more than one value",
          {
            expect_gt(length(
              get_play_spoken_text("rus", "pushkin-boris-godunov", "UNKNOWN")
            ),
            1)
          })

test_that("get_play_spoken_text_bych() returns data.frame", {
  expect_type(get_play_spoken_text_bych("rus", "pushkin-boris-godunov"),
              "list")
})

test_that("get_play_stage_directions() returns text", {
  expect_type(get_play_stage_directions("rus", "pushkin-boris-godunov"),
              "character")
})

test_that("get_play_stage_directions_with_sp() returns text", {
  expect_type(get_play_stage_directions_with_sp("rus", "pushkin-boris-godunov"),
              "character")
})

test_that("get_sparql() returns xml_document", {
  expect_s3_class(get_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10"), "xml_document")
})

test_that("get_sparql() with parse = FALSE returns character", {
  expect_type(get_sparql("SELECT * WHERE {?s ?p ?o} LIMIT 10", parse = FALSE), "character")
})

test_that("play_igraph is returned by play_igraph()", {
  expect_s3_class(play_igraph("rus", "gogol-zhenitba"), "play_igraph")
})

test_that("label_play_igraph() return come NA for big network", {
  henryiv <- play_igraph("shake", "henry-iv-part-i")
  expect_true(any(is.na(label_play_igraph(henryiv))))
})

test_that("label_play_igraph() do not return NA after max_graph_size adjustment", {
  henryiv <- play_igraph("shake", "henry-iv-part-i")
  expect_true(all(!is.na(label_play_igraph(henryiv, max_graph_size = 36))))
})

test_that("summary.play_igraph() prints appropriate number of rows", {
  henryiv <- play_igraph("shake", "henry-iv-part-i")
  expect_equal(length(capture.output(summary(henryiv))), 14L)
})
