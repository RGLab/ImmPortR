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

POST_upload <- function(path, body) {
  token <- get_token()

  res <- POST(
    url = UPLOAD_URL,
    path = path,
    body = body,
    encode = "multipart",
    config = config(useragent = get_useragent()),
    add_headers(Authorization = paste("bearer", token))
  )

  res <- content(res)

  if (!is.null(res$error)) {
    stop(res$message)
  }

  res
}

#' @importFrom httr upload_file
upload_online <- function(file_path, workspace_id, package_name, upload_notes, upload_purpose) {
  path <- c(
    "data",
    "upload",
    "type",
    "online"
  )

  body <- list(
    workspaceId = workspace_id,
    packageName = package_name,
    uploadNotes = upload_notes,
    uploadPurpose = upload_purpose,
    serverName = "",
    file = upload_file(file_path)
  )

  POST_upload(path, body)
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

#' Validate a Zip File
#'
#' @param file_path A character. File path to the zip file to upload.
#' @param workspace_id An integer.
#' @param upload_notes A character. Optional.
#'
#' @return A character. Ticket.
#'
#' @references \url{http://docs.immport.org/#API/DataUploadAPI/datauploadapi/#zip-file-upload-for-validation-with-authentication}
#'
#' @examples
#' \dontrun{
#' validate_zip("groundbreakingStudy.zip")
#' }
#' @export
validate_zip <- function(file_path, workspace_id, upload_notes = "") {
  stopifnot(length(file_path) == 1)
  stopifnot(is.character(file_path))
  stopifnot(file.exists(file_path))
  stopifnot(tools::file_ext(file_path) == "zip")

  upload_online(
    file_path = file_path,
    workspace_id = workspace_id,
    package_name = "",
    upload_notes = upload_notes,
    upload_purpose = "validateData"
  )
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
