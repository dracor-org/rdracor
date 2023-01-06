test_that("get_net_edges returns list", {
  expect_type(get_net_metrics("pushkin-boris-godunov", "rus"), "list")
})

test_that("column names for get_net_edges() are valid", {
  expect_equal(
    names(get_net_edges("pushkin-boris-godunov", "rus")),
    c("Source", "Type", "Target", "Weight")
  )
})

test_that("get_net_gexf() returns valid object", {
  gexf <- get_net_gexf("pushkin-boris-godunov", "rus")
  expect_equal(
    as.character(xml2::xml_contents(
      xml2::xml_contents(xml2::xml_children(gexf)[1])[1]
    )),
    "dracor.org"
  )
})

test_that("net_igraph is returned by net_igraph()", {
  expect_s3_class(get_net_igraph("gogol-zhenitba", "rus"), "net_igraph")
})

test_that("label_net_igraph() return come NA for big network", {
  henryiv <- get_net_igraph("henry-iv-part-i", "shake")
  expect_true(any(is.na(label_net_igraph(henryiv))))
})

test_that("label_net_igraph() do not return NA after max_graph_size adjustment", {
  henryiv <- get_net_igraph("henry-iv-part-i", "shake")
  expect_true(all(!is.na(label_net_igraph(henryiv, max_graph_size = 36))))
})

test_that("summary.net_igraph() prints appropriate number of rows", {
  henryiv <- get_net_igraph("henry-iv-part-i", "shake")
  expect_equal(length(capture.output(summary(henryiv))), 14L)
})
