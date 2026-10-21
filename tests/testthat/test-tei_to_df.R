test_that("tei_to_df converts tei object to tibble", {
  skip_if_no_dracor()
  expect_s3_class(
    tei_to_df(get_text_tei(corpus = "rus", play = "gogol-zhenitba")),
    "tbl_df"
  )
})

test_that("get_text_df returns tibble", {
  skip_if_no_dracor()
  expect_s3_class(
    get_text_df(corpus = "rus", play = "gogol-zhenitba"),
    "tbl_df"
  )
})

test_that("tei_to_df() keeps the speaker for verse lines inside <lg>", {
  tei <- xml2::read_xml('
    <TEI xmlns="http://www.tei-c.org/ns/1.0"><text><body>
      <div type="act"><head>Act 1</head>
        <div type="scene"><head>Scene 1</head>
          <sp who="#a"><speaker>A</speaker><lg><l>verse one</l><l>verse two</l></lg></sp>
          <sp who="#b"><speaker>B</speaker><p>prose</p></sp>
          <sp who="#a #b"><speaker>BOTH</speaker><l>together</l></sp>
          <stage>enter C</stage>
        </div>
      </div>
    </body></text></TEI>')
  n_ns <- length(xml2::xml_ns(tei))
  df <- tei_to_df(tei)
  expect_equal(df$who[df$text %in% c("verse one", "verse two")], c("a", "a"))
  expect_equal(df$who[df$text == "prose"], "b")
  expect_equal(df$who[df$text == "together"], "a b")
  expect_true(is.na(df$who[df$type == "stage"]))
  # the input document is not modified
  expect_equal(length(xml2::xml_ns(tei)), n_ns)
})
