# These tests do not need the internet: they check that the functions fail
# gracefully (informative message and NULL, no error) if 'DraCor' API is not
# available

test_that("dracor_api_available() returns FALSE if API is not available", {
  expect_false(dracor_api_available("http://127.0.0.1:9/api/v1"))
})

test_that("dracor_api() returns NULL with a message if API is not available", {
  expect_message(
    res <- dracor_api("http://127.0.0.1:9/api/v1/info"),
    "Could not connect to 'DraCor' API"
  )
  expect_null(res)
})

test_that("dracor_api_info() does not fail if API is not available", {
  expect_message(
    expect_output(
      with_unavailable_dracor(dracor_api_info()),
      "DraCor API was not found"
    ),
    "Could not connect to 'DraCor' API"
  )
})

test_that("functions return NULL with a message if API is not available", {
  with_unavailable_dracor({
    expect_message(expect_null(get_dracor_meta()), "DraCor")
    expect_message(expect_null(get_dracor("tat")), "DraCor")
    expect_message(expect_null(get_dracor()), "DraCor")
    expect_message(expect_null(get_character_plays("Q131412")), "DraCor")
    expect_message(
      expect_null(get_play_metadata("gogol-zhenitba", "rus")),
      "DraCor"
    )
    expect_message(
      expect_null(get_play_characters("gogol-zhenitba", "rus")),
      "DraCor"
    )
    expect_message(
      expect_null(get_net_cooccur_metrics("gogol-zhenitba", "rus")),
      "DraCor"
    )
    expect_message(
      expect_null(get_net_cooccur_igraph("gogol-zhenitba", "rus")),
      "DraCor"
    )
    expect_message(
      expect_null(get_net_relations_igraph("gogol-zhenitba", "rus")),
      "DraCor"
    )
    expect_message(
      expect_null(get_text_chr_spoken_bych("gogol-zhenitba", "rus")),
      "DraCor"
    )
    expect_message(
      expect_null(get_text_df("gogol-zhenitba", "rus")),
      "DraCor"
    )
  })
})
