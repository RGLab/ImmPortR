# GLOBAL VARIABLES -------------------------------------------------------------

UPLOAD_URL <- "https://immport-upload.niaid.nih.gov:8443"


# HELPER FUNCTIONS -------------------------------------------------------------

GET_upload <- function(path) {
  token <- get_token()

  res <- GET(
    url = UPLOAD_URL,
    path = path,
    config = config(useragent = get_useragent()),
    add_headers(Authorization = paste("bearer", token))
  )

  res <- content(res)

  if (!is.null(res$error)) {
    stop(res$message)
  }

  res
}


# MAIN FUNCTIONS ---------------------------------------------------------------

#' Generate Documentation Templates
#'
#' @param workspace_id An integer. ID specific to a workspace.
#' @param output_dir A character. Output directory.
#'
#' @return A character.
#'
#' @references \url{http://docs.immport.org/#API/DataUploadAPI/datauploadapi/#documentation-generation-request-with-authentication}
#'
#' @examples
#' \dontrun{
#' generate_templates(workspace_id = 999999)
#' }
#'
#' @seealso \code{\link{list_workspaces}}
#'
#' @importFrom httr write_disk
#' @export
generate_templates <- function(workspace_id, output_dir = ".") {
  path <- c(
    "data",
    "upload",
    "documentation",
    "templates",
    workspace_id
  )
  token <- get_token()
  output_file <- file.path(output_dir, paste0("ImmportTemplates.", workspace_id, ".zip"))

  res <- GET(
    url = UPLOAD_URL,
    path = path,
    config = config(useragent = get_useragent()),
    add_headers(Authorization = paste("bearer", token)),
    write_disk(output_file, overwrite = TRUE)
  )

  if (res$status_code != 200) {
    stop(content(res)$message, {file.remove(output_file); NULL})
  }

  output_file
}

#' Retreive Set of Workspaces
#'
#' @return A list. Set of workspaces on which a user can perform and upload or
#' validation.
#'
#' @references \url{http://docs.immport.org/#API/DataUploadAPI/datauploadapi/#set-of-workspaces-request-with-authentication}
#'
#' @examples
#' \dontrun{
#' list_workspaces()
#' }
#'
#' @export
list_workspaces <- function() {
  path <- "workspaces"

  GET_upload(path)$workspaces
}

#' Check Status of Upload/Validation Ticket
#'
#' @param ticket A character.
#'
#' @return A character.
#'
#' @references \url{http://docs.immport.org/#API/DataUploadAPI/datauploadapi/#status-of-upload-ticket-with-authentication}
#'
#' @examples
#' \dontrun{
#' check_status("testuser_20180523_19544")
#' }
#' @export
check_status <- function(ticket) {
  path <- c(
    "data",
    "upload",
    "registration",
    ticket,
    "status"
  )

  GET_upload(path)$status
}

#' Retrieve Summary Information on Upload/Validation Ticket
#'
#' @param ticket A character.
#'
#' @return A list.
#'
#' @references \url{http://docs.immport.org/#API/DataUploadAPI/datauploadapi/#summary-information-on-upload-ticket-request-with-authentication}
#'
#' @examples
#' \dontrun{
#' get_ticket_summary("testuser_20180523_19544")
#' }
#'
#' @export
get_ticket_summary <- function(ticket) {
  path <- c(
    "data",
    "upload",
    "registration",
    ticket,
    "reports",
    "summary"
  )

  GET_upload(path)$summary
}

#' Retrieve Database Report on a Upload/Validation Ticket
#'
#' @param ticket A character.
#'
#' @return A character. Raw text of the report.
#'
#' @references \url{http://docs.immport.org/#API/DataUploadAPI/datauploadapi/#database-information-on-upload-ticket-request-with-authentication}
#'
#' @examples
#' \dontrun{
#' get_ticket_report("testuser_20180523_19544")
#' }
#'
#' @export
get_ticket_report <- function(ticket) {
  path <- c(
    "data",
    "upload",
    "registration",
    ticket,
    "reports",
    "database"
  )

  text <- GET_upload(path)$database

  if (is.null(text)) {
    stop(
      "No upload/validation report available for the uploadTicketNumber - ",
      ticket
    )
  }

  text
}
