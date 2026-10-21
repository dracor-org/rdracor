test_that("get_net_cooccur_metrics returns list", {
  skip_if_no_dracor()
  expect_type(get_net_cooccur_metrics("pushkin-boris-godunov", "rus"), "list")
})

test_that("column names for get_net_cooccur_edges() are valid", {
  skip_if_no_dracor()
  expect_equal(
    names(get_net_cooccur_edges("pushkin-boris-godunov", "rus")),
    c("Source", "Type", "Target", "Weight")
  )
})

test_that("get_net_cooccur_gexf() returns valid object", {
  skip_if_no_dracor()
  gexf <- get_net_cooccur_gexf("pushkin-boris-godunov", "rus")
  expect_equal(
    as.character(xml2::xml_contents(
      xml2::xml_contents(xml2::xml_children(gexf)[1])[1]
    )),
    "dracor.org"
  )
})

test_that("cooccur_igraph is returned by get_net_cooccur_igraph()", {
  skip_if_no_dracor()
  expect_s3_class(
    get_net_cooccur_igraph("gogol-zhenitba", "rus"),
    "cooccur_igraph"
  )
})

test_that("label_cooccur_igraph() return come NA for big network", {
  skip_if_no_dracor()
  henryiv <- get_net_cooccur_igraph("henry-iv-part-1", "shake")
  expect_true(any(is.na(label_cooccur_igraph(henryiv))))
})

test_that(
  "label_cooccur_igraph() do not return NA after max_graph_size adjustment",
  {
    skip_if_no_dracor()
    henryiv <- get_net_cooccur_igraph("henry-iv-part-1", "shake")
    expect_true(all(!is.na(label_cooccur_igraph(henryiv, max_graph_size = 36))))
  }
)

test_that("summary.cooccur_igraph() prints appropriate number of rows", {
  skip_if_no_dracor()
  henryiv <- get_net_cooccur_igraph("henry-iv-part-1", "shake")
  expect_equal(length(capture.output(summary(henryiv))), 15L)
})

test_that("relations_igraph is returned by get_net_relations_igraph()", {
  skip_if_no_dracor()
  expect_s3_class(
    get_net_relations_igraph("gogol-zhenitba", "rus"),
    "relations_igraph"
  )
})

test_that("plot methods accept igraph arguments and custom gender_colors", {
  skip_if_no_dracor()
  # a play with ASCII character names: the pdf device cannot draw Cyrillic
  # labels in a non-UTF-8 locale
  pdf(NULL)
  cooccur <- get_net_cooccur_igraph("lessing-emilia-galotti", "ger")
  expect_silent(plot(cooccur, vertex.color = "red", vertex.size = 5))
  expect_silent(plot(cooccur, edge_size_scale = NULL))
  expect_silent(
    plot(cooccur, gender_colors = c(FEMALE = "red", MALE = "blue", UNKNOWN = "grey"))
  )
  expect_silent(plot(cooccur, gender_colors = NULL))
  expect_error(plot(cooccur, gender_colors = c("red", "blue", "grey")), "gender_colors")
  relations <- get_net_relations_igraph("lessing-emilia-galotti", "ger")
  expect_silent(plot(relations, main = "Emilia Galotti", vertex.color = "red"))
  expect_silent(plot(relations, show_others = "none"))
  dev.off()
})
