QUERY_URL <- "https://api.immport.org"

#' @importFrom httr GET add_headers
#' @importFrom jsonlite fromJSON
query <- function(endpoint, query = NULL) {
  token <- get_token()

  res <- GET(
    url = QUERY_URL,
    path = c("data", "query", endpoint),
    query = query,
    config = config(useragent = get_useragent()),
    add_headers(Authorization = paste("bearer", token))
  )

  if (res$status_code != 200) {
    stop(content(res)$error, call. = FALSE)
  }

  raw <- content(res, as = "text")
  parsed <- fromJSON(raw)

  if (length(parsed) == 0) {
    warning("'", endpoint, "' is empty...", call. = FALSE, immediate. = TRUE)
    parsed <- data.frame()
  }

  parsed
}

#' query dataset by study accession
#'
#' @param study a character. study accession.
#' @param dataset a character. dataset name. Datasets are "elisa", "elispot",
#' "fcsAnalyzed", "hai", "hlaTyping", "kirTyping", "mbaa", "neutAbTiter", "pcr"
#'
#' @return A data.frame.
#'
#' @references \url{http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/}
#'
#' @examples
#' \dontrun{
#' elisa <- query_dataset("SDY269", "elisa")
#' elispot <- query_dataset("SDY269", "elispot")
#' fcsAnalyzed <- query_dataset("SDY269", "fcsAnalyzed")
#' hai <- query_dataset("SDY269", "hai")
#' hlaTyping <- query_dataset("SDY269", "hlaTyping")
#' kirTyping <- query_dataset("SDY269", "kirTyping")
#' mbaa <- query_dataset("SDY269", "mbaa")
#' neutAbTiter <- query_dataset("SDY269", "neutAbTiter")
#' pcr <- query_dataset("SDY269", "pcr")
#' }
#' @export
query_dataset <- function(study, dataset) {
  dataset_list <- c(
    "elisa",
    "elispot",
    "fcsAnalyzed",
    "hai",
    "hlaTyping",
    "kirTyping",
    "mbaa",
    "neutAbTiter",
    "pcr"
  )

  stopifnot(length(dataset) == 1)
  if (!dataset %in% dataset_list) {
    stop(
      "'", dataset, "' is an invalid dataset name. ",
      "Valid dataset names are: ", paste(dataset_list, collapse = ", ")
    )
  }


  query(c("result", dataset), list(studyAccession = study))
}

#' query file path by study acession
#'
#' @param study a character. study accession.
#'
#' @return A data.frame.
#'
#' @references \url{http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/#example-of-a-request-on-the-filepath-endpoint}
#'
#' @examples
#' \dontrun{
#' query_filePath("SDY269")
#' }
#' @export
query_filePath <- function(study) {
  query(c("result", "filePath"), list(studyAccession = study))
}


#' query a list of all study accessions
#'
#' @return A vector.
#'
#' @references \url{http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/}
#'
#' @examples
#' \dontrun{
#' query_findAllStudyAccessions()
#' }
#' @export
query_findAllStudyAccessions <- function() {
  query(c("study", "findAllStudyAccessions"))$studyAccessions
}

#' query the latest study data release version
#'
#' @return A character.
#'
#' @references \url{http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/}
#'
#' @examples
#' \dontrun{
#' query_datarelversion()
#' }
#' @export
query_datarelversion <- function() {
  query(c("studydatarel", "datarelver"))[[1]]
}

#' query the study summary
#'
#' @param study a character. study accession.
#'
#' @return A list
#'
#' @references \url{http://docs.immport.org/#API/DataQueryAPI/dataqueryapi/}
#'
#' @examples
#' \dontrun{
#' query_study_summary()
#' }
#' @export
query_study_summary <- function(study) {
  query(c("study", "summary", study))
}
