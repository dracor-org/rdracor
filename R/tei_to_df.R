parse_line <- function(line,
                       regex_remove_full,
                       regex_extract_inline,
                       regex_extract_segment_type) {
  `.` <- type <- type_attributes <- NULL # to pass check

  text_line <- line %>%
    stringr::str_remove_all(regex_remove_full)

  line_parts <- text_line %>%
    stringr::str_split(regex_extract_inline) %>%
    purrr::flatten_chr() %>%
    stringr::str_remove_all("<\\s*([^\\s>]+)([^>]*)\\s*>") %>%
    stringr::str_squish()

  general_type_attr <- text_line %>%
    stringr::str_extract(regex_extract_segment_type) %>%
    stringr::str_remove_all("[<>]")  %>%
    stringr::str_split("\\s", n = 2, simplify = TRUE) %>%
    c()

  line_tags <- text_line %>%
    stringr::str_extract_all(regex_extract_inline) %>%
    purrr::flatten_chr() %>%
    stringr::str_extract("<[^/].*>") %>%
    stringr::str_remove_all("[<>]") %>%
    stringr::str_split("\\s", n = 2, simplify = TRUE) %>%
    data.table::data.table() %>%
    list(
      data.table::data.table(type = general_type_attr[1],
                             type_attributes = general_type_attr[2]),
      .
    ) %>%
    data.table::rbindlist(use.names = FALSE) %>%
    .[is.na(type), type := general_type_attr[1]] %>%
    .[is.na(type_attributes), type_attributes := general_type_attr[2]]

  lines_dt <-
    line_tags[, text := line_parts][stringr::str_detect(text, "[:alnum:]+"),
                                    .(text, type, type_attributes)]

  return(lines_dt)
}

segment_info <- function(tei_line, sep = " | ") {

  position <- tei_line %>%
    xml2::xml_path() %>%
    stringr::str_remove(fixed("/TEI/text/body/")) %>%
    stringr::str_split("/", simplify = TRUE) %>%
    stringr::str_extract("[:digit:]+") %>%
    tidyr::replace_na("1")

  div_xml <- tei_line %>%
    xml2::xml_parents() %>%
    head(-3)

  div_types <- div_xml %>%
    xml2::xml_attr("type") %>%
    rev()

  scene <- div_xml %>%
    xml2::xml_child("head") %>%
    xml2::xml_text() %>%
    rev() %>%
    na.omit() %>%
    paste(collapse = sep)

  divs <- div_xml %>%
    xml2::xml_name() %>%
    rev()

  scene_path <-  paste(div_types[!is.na(div_types)],
                       head(position, -1)[!is.na(div_types)], collapse = sep)


  subdiv_path <- paste(c(divs[divs != "div"], xml_name(tei_line)),
                       c(position[divs != "div"], tail(position, 1)), collapse = sep)

  who <- tei_line %>%
    xml2::xml_parent() %>% #map to avoid deduplication
    xml2::xml_attr("who") %>%
    stringr::str_remove("#")

  data.table::data.table(who, scene, scene_path, subdiv_path)
}

line_table <- function(tei_line,
                       regex_remove_full,
                       regex_extract_inline,
                       regex_extract_segment_type) {
  line_info <- tei_line %>%
    segment_info()
  line_text <- tei_line %>%
    as.character() %>%
    parse_line(regex_remove_full,
               regex_extract_inline,
               regex_extract_segment_type)

  line_text[, c(.SD, line_info)]
}

#' Retrieve a text for a play as a data frame
#'
#' The function \code{get_text_df} returns you a data frame with text of
#' the selected play. \code{tei_to_df} allows to convert an existing TEI object
#' to a data frame.
#'
#' @return Text of a play as a data frame in
#' \href{https://www.tidytextmining.com/tidytext.html}{tidy text} format.
#'
#' Each row represent one token. The text tokenized by lines, notes and stage
#' directions (<p>, <l>, <stage> or <note>).
#'
#' Column \code{text} contains text of the line, other columns contain metadata
#' for the line.
#' @param tei A TEI object stored as an object of class \code{xml_document}.
#' You can use this function if you have already downloaded TEI using
#' \code{\link{get_text_tei}}.
#' @examples
#' \dontrun{
#' get_text_df(play = "gogol-zhenitba", corpus = "rus")
#' zhenitba <- get_text_tei(play = "gogol-zhenitba", corpus = "rus")
#' tei_to_df(zhenitba)
#' }
#' @seealso \code{\link{get_play_metadata}}
#' @importFrom purrr flatten_chr
#' @importFrom tibble as_tibble
#' @importFrom stats na.omit
#' @importFrom utils head tail
#' @importFrom tidyr replace_na
#' @import data.table
#' @import stringr
#' @export
tei_to_df <- function(tei) {
  line_id <- scene_id <- scene_path <- NULL # to pass check
  tags_text <-
    c("l", "p") #these will be tokens for the dataframe, they cannot be inside metatext tokens

  regex_remove_tags_text <-
    paste0("(</?", tags_text, "([^>]*)>)", collapse = "|")

  not_parents <-
    paste0("not(parent::", tags_text, ")", collapse = " and ")

  tags_metatext <-
    c("stage", "note") #these will be tokens for the dataframe, they can be both inside text tokens or outside

  regex_extract_inline <-
    paste0("(</?", tags_metatext, "([^>]*)>)", collapse = "|")

  regex_extract_segment_type <-
    paste0("(</?", c(tags_text, tags_metatext), "([^>]*)>)", collapse = "|")

  tags_remove_self_closed <-
    c("lb", "pb", "graphic") #self-closed tags. As for now, all self-closed tags will be ignored

  tags_remove_save_content <-
    c("emph", "term", "quote", "cit", "lg", "phr", "w", "pc", "cl", "c") #tags that will be ignored but
  #their content will be saved.

  tags_remove_drop_content <-
    c("ref", "bibl") #tags that will be ignored and their content will be dropped from the results

  regex_remove_self_closed <-
    paste0("(<", tags_remove_self_closed, "/>)", collapse = "|")

  regex_remove_tags_save_content <-
    paste0("(</?", tags_remove_save_content, "([^>]*)>)", collapse = "|")

  regex_remove_tags_drop_content <-
    paste0(
      "(<",
      tags_remove_drop_content,
      "([^>]*)>[^>]*</",
      tags_remove_drop_content,
      ">)",
      collapse = "|"
    )

  regex_remove_full <- paste(
    regex_remove_self_closed,
    regex_remove_tags_save_content,
    regex_remove_tags_drop_content,
    sep = "|"
  )


  path_tei_root <- "/TEI/text/body//"

  xpath <- paste0(path_tei_root,
                  c(tags_text,
                    paste0(tags_metatext, "[", not_parents, "]")),
                  collapse = " | ")

  tei %>%
    xml2::xml_ns_strip()
  play_text_df <- tei %>%
    xml2::xml_find_all(xpath) %>%
    lapply(line_table,
           regex_remove_full,
           regex_extract_inline,
           regex_extract_segment_type) %>%
    data.table::rbindlist(idcol = "subdiv_id")
  play_text_df[, line_id := .I]
  play_text_df[, scene_id := .GRP, by = scene_path]
  data.table::setcolorder(
    play_text_df,
    c(
      "text",
      "type",
      "type_attributes",
      "who",
      "scene",
      "scene_path",
      "subdiv_path",
      "line_id",
      "subdiv_id",
      "scene_id"
    )
  )
  tibble::as_tibble(play_text_df[])
}

#' @inheritParams get_play_metadata
#' @export
#' @describeIn tei_to_df Retrieve all stage directions of a play,
#' given corpus and play names.
get_text_df <- function(play, corpus) {
  get_text_tei(play = play, corpus = corpus) %>%
    tei_to_df()
}
