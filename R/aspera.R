#' List file or directory from ImmPort
#'
#' @param path A character. File or directory to list
#'
#' @return A list.
#'
#' @examples
#' \dontrun{
#' list_immport("/SDY1/StudyFiles")
#' }
#' @export
#' @importFrom jsonlite toJSON
list_immport <- function(path) {
  token <- get_token()
  body <- toJSON(list(path = path), auto_unbox = TRUE)

  res <- POST(
    url = "https://api.immport.org/data/list",
    add_headers(
      Authorization = paste("bearer", token),
      "Content-Type" = "application/json"
    ),
    body = body
  )

  content(res)
}

get_aspera_token <- function(path, token) {
  body <- toJSON(list(paths = path))

  res <- POST(
    url = "https://api.immport.org/data/download/token",
    add_headers(
      Authorization = paste("bearer", token),
      "Content-Type" = "application/json"
    ),
    body = body
  )

  content(res)$token
}

install_aspera <- function(immport, file_name, file_url) {
  message("Downloading '", file_name, "'...")
  tool_path <- file.path(immport, file_name)
  download.file(
    url = file_url,
    destfile = tool_path,
    quiet = TRUE
  )

  message("Unzipping '", file_name, "'...")
  suppressMessages(unzip(tool_path, exdir = immport, unzip = getOption("unzip")))
}

#' @importFrom utils download.file unzip
#' @importFrom httr HEAD
get_aspera <- function() {
  immport <- file.path(Sys.getenv("HOME"), ".immport")
  file_name <- "immport-data-download-tool.zip"
  file_url <- file.path("http://www.immport.org/downloads/data/download/tool", file_name)
  folder_name <- gsub(".zip", "", file_name)
  folder_path <- file.path(immport, folder_name)

  if (!dir.exists(immport)) {
    message("Creating '", immport, "' directory...")
    dir.create(immport)

    install_aspera(immport, file_name, file_url)
  } else {
    file_local <- paste0(folder_path, ".zip")

    if (!file.exists(folder_path)) {
      suppressWarnings(file.remove(file_local))
      install_aspera(immport, file_name, file_url)
    } else {
      file_head <- HEAD(file_url)

      if (file_head$status_code != 200) {
        stop("The download tool is not available at ", file_url)
      }

      file_modified <- as.POSIXct(file_head$headers$`last-modified`, format = "%a, %d %B %Y %X", tz = "GMT")
      folder_created <- file.info(folder_path)[1, "ctime"]

      if (file_modified > folder_created) {
        message("The download tool is outdated.")

        message("Removing '", folder_path, "'...")
        unlink(folder_path, recursive = TRUE)

        message("Removing '", file_local, "'...")
        suppressWarnings(file.remove(file_local))

        install_aspera(immport, file_name, file_url)
      }
    }
  }

  file.path(folder_path, "aspera")
}

#' Downlaod file or directory from ImmPort
#'
#' @param path A character. File or directory to download.
#' @param output_dir A character. Output directory.
#'
#' @examples
#' \dontrun{
#' download_immport("/SDY1/StudyFiles/Casale_Study_Summary_Report.doc")
#' }
#' @export
download_immport <- function(path, output_dir = ".") {
  token <- get_token()
  aspera_token <- get_aspera_token(path, token)

  os <- get_os()
  aspera <- get_aspera()
  ascp <- file.path(aspera, "cli", "bin", os, "ascp")
  key_file <- file.path(aspera, "cli", "etc", "asperaweb_id_dsa.openssh")

  command <- paste0(
    ascp,
    " -v",
    # " -L ", output_dir,
    " -i ", key_file,
    " -O ", "33001",
    " -P ", "33001",
    " -W ", aspera_token,
    " --user=databrowser",
    " aspera-immport.niaid.nih.gov:'", path, "' ",
    output_dir
  )

  message("Downloading '", path, "'...")
  system(command)
}

get_os <- function() {
  if (.Platform$OS.type == "windows") {
    stop("Windows is not currently supported")
  } else if (Sys.info()["sysname"] == "Darwin") {
    "osx"
  } else if (.Platform$OS.type == "unix") {
    if (Sys.info()["machine"] == "x86_64") {
      "linux"
    } else if (Sys.info()["machine"] == "x86_32") {
      "linux32"
    } else {
      stop("Unknown arch")
    }
  } else {
    stop("Unknown OS")
  }
}
