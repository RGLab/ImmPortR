#' @importFrom httr GET add_headers
query <- function(endpoint, study) {
  token <- get_token(
    username = getOption("ImmPortUsername"),
    password = getOption("ImmPortPassword")
  )

  res <- GET(
    url = paste0("https://api.immport.org/data/query/result/", endpoint),
    query = list(studyAccession = study),
    add_headers(Authorization = paste("bearer", token))
  )

  if (res$status_code != 200) {
    stop(content(res)$error, call. = FALSE)
  }

  res
}

#' query dataset by study accession
#'
#' @param dataset a character. dataset name.
#' @param study a character. study accession.
#'
#' @return list
#'
#' @examples
#' \dontrun{
#' elisa <- query_dataset("elisa", "SDY269")
#' elispot <- query_dataset("elispot", "SDY269")
#' fcsAnalyzed <- query_dataset("fcsAnalyzed", "SDY269")
#' hai <- query_dataset("hai", "SDY269")
#' hlaTyping <- query_dataset("hlaTyping", "SDY269")
#' kirTyping <- query_dataset("kirTyping", "SDY269")
#' mbaa <- query_dataset("mbaa", "SDY269")
#' neutAbTiter <- query_dataset("neutAbTiter", "SDY269")
#' pcr <- query_dataset("pcr", "SDY269")
#' }
#' @export
query_dataset <- function(dataset, study) {
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
  if (!dataset %in% dataset_list) {
    stop("'", dataset, "' is an invalid dataset name. ",
         "Valid dataset names are: ", paste(dataset_list, collapse = ", "))
  }

  query(dataset, study)
}
