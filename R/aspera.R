#' @importFrom jsonlite toJSON
list_file <- function(file) {
  token <- get_token(
    username = getOption("ImmPortUsername"),
    password = getOption("ImmPortPassword")
  )
  body <- toJSON(list(path = file), auto_unbox = TRUE)

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

get_aspera_token <- function(file, token) {
  body <- toJSON(list(paths = file))

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

#' @importFrom utils download.file unzip
get_aspera <- function() {
  immport <- file.path(Sys.getenv("HOME"), ".immport")

  if (!dir.exists(immport)) {
    message("Creating '", immport, "' directory...")
    dir.create(immport)

    message("Downloading 'immport-data-download-tool'...")
    tool_path <- file.path(immport, "immport-data-download-tool.zip")
    download.file(
      url = "http://www.immport.org/downloads/data/download/tool/immport-data-download-tool.zip",
      destfile = tool_path
    )

    message("Unzipping 'immport-data-download-tool.zip'...")
    suppressMessages(unzip(tool_path, exdir = immport, unzip = getOption("unzip")))
  }

  file.path(immport, "immport-data-download-tool", "aspera")
}

download_file <- function(file, output_dir = ".") {
  token <- get_token(
    username = getOption("ImmPortUsername"),
    password = getOption("ImmPortPassword")
  )
  aspera_token <- get_aspera_token(file, token)
  os <- get_os()
  aspera <- get_aspera()
  ascp <- file.path(aspera, "cli", "bin", os, "ascp")
  key_file <- file.path(aspera, "cli", "etc", "asperaweb_id_dsa.openssh")

  command <- paste0(
    ascp,
    " -v",
    " -L ", output_dir,
    " -i ", key_file,
    " -O ", "33001",
    " -P ", "33001",
    " -W ", aspera_token,
    " --user=databrowser",
    " aspera-immport.niaid.nih.gov:'", file, "' ",
    output_dir
  )

  message("Downloading '", file, "'...")
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
