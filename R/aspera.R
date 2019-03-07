#' List file or directory from ImmPort
#'
#' @param path A character. File or directory to list
#'
#' @return A list.
#'
#' @references \url{http://docs.immport.org/#API/FileDownloadAPI/filedownloadapi/#example-for-listing-a-shared-data-directory-or-file}
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
    url = QUERY_URL,
    path = c("data", "list"),
    config = config(useragent = get_useragent()),
    add_headers(
      Authorization = paste("bearer", token),
      "Content-Type" = "application/json"
    ),
    body = body
  )

  res <- content(res)

  if (!is.null(res$error)) {
    stop(res$message)
  }

  if (!is.null(res$self)) {
    res$self$permissions <-paste(
      unlist(res$self$permissions, use.names = FALSE),
      collapse = ","
    )
    res$self <- as.data.frame(res$self, stringsAsFactors = FALSE)
  }

  if (!is.null(res$items)) {
    res$items <- lapply(res$items, function(item) {
      item$permissions <- paste(
        unlist(item$permissions, use.names = FALSE),
        collapse = ","
      )
      item$fileCount <- ifelse(is.null(item$fileCount), NA, item$fileCount)
      as.data.frame(item, stringsAsFactors = FALSE)
    })

    if (length(res$items) == 0) {
      res$items <- data.frame()
    } else {
      res$items <- do.call(rbind, res$items)
    }
  }

  res
}

get_aspera_token <- function(path, token) {
  body <- toJSON(list(paths = path))

  res <- POST(
    url = QUERY_URL,
    path = c("data", "download", "token"),
    config = config(useragent = get_useragent()),
    add_headers(
      Authorization = paste("bearer", token),
      "Content-Type" = "application/json"
    ),
    body = body
  )

  res <- content(res)

  if (!is.null(res$error)) {
    stop(res$message)
  }

  res
}

get_aspera_path <- function() {
  if (.Platform$OS.type == "windows") {
    "C:/aspera/cli"
  } else if (Sys.info()["sysname"] == "Darwin") {
    file.path(Sys.getenv("HOME"), "Applications/Aspera CLI")
  } else if (.Platform$OS.type == "unix") {
    file.path(Sys.getenv("HOME"), ".aspera/cli")
  } else {
    stop("Unsupported operating system...")
  }
}

check_path <- function(path) {
  if (!file.exists(path)) {
    stop(
      path, " does not exist. Check your Apsera CLI installation.\n",
      "  Download and install Aspera CLI if you haven't already done so.\n",
      "  https://downloads.asperasoft.com/en/documentation/62"
    )
  }
}

get_aspera <- function(aspera_path) {
  if (is.null(aspera_path)) {
    aspera_path <- get_aspera_path()
  }

  bin <- ifelse(.Platform$OS.type == "windows", "ascp.exe", "ascp")
  ascp <- file.path(aspera_path, "bin", bin)
  key_file <- file.path(aspera_path, "etc", "asperaweb_id_dsa.openssh")

  check_path(aspera_path)
  check_path(ascp)
  check_path(key_file)

  list(ascp = ascp, key_file = key_file)
}

#' Downlaod file or directory from ImmPort
#'
#' @param path A character. File or directory to download.
#' @param output_dir A character. Output directory.
#' @param aspera_path A charater. Path to Aspera CLI installation.
#' @param verbose A logical. Show stdout/stderr from Aspera.
#'
#' @return A list with components:
#'   * status The exit status of the process. If this is `NA`, then the
#'     process was killed and had no exit status.
#'   * stdout The standard output of the command, in a character scalar.
#'   * stderr The standard error of the command, in a character scalar.
#'   * timeout Whether the process was killed because of a timeout.
#'
#' @references \url{http://docs.immport.org/#API/FileDownloadAPI/filedownloadapi/#example-of-manual-steps-to-download-a-file}
#'
#' @examples
#' \dontrun{
#' download_immport("/SDY1/StudyFiles/Casale_Study_Summary_Report.doc")
#' }
#' @export
#' @importFrom processx run
download_immport <- function(path, output_dir = ".", aspera_path = NULL, verbose = FALSE) {
  if (file.access(output_dir, mode = 2) == -1) {
    stop("You do not have write permission to '", output_dir, "'.")
  }

  aspera <- get_aspera(aspera_path)
  token <- get_token()
  aspera_token <- get_aspera_token(path, token)

  args <- c(
    "-v",
    # "-L", output_dir,
    "-i", aspera$key_file,
    "-O", "33001",
    "-P", "33001",
    "-W", aspera_token$token,
    "--user=databrowser",
    paste0("aspera-immport.niaid.nih.gov:", path),
    output_dir
  )

  message("Downloading '", path, "'...")
  invisible(run(
    command = aspera$ascp,
    args = args,
    echo = verbose,
    echo_cmd = verbose,
    spinner = TRUE
  ))
}
