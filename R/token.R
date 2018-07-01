#' @importFrom httr POST content config
get_token <- function(username = Sys.getenv("ImmPortUsername"),
                      password = Sys.getenv("ImmPortPassword")) {
  if (is.null(username)) stop("set username")
  if (is.null(password)) stop("set password")

  if (!is.null(getOption("ImmPortToken"))) {
    diff <- difftime(Sys.time(), getOption("ImmPortTokenTime"), units = "secs")
    if (diff < 50) {
      return(getOption("ImmPortToken"))
    }
  }

  res <- POST(
    url = "https://auth.immport.org/auth/token",
    body = list(username = username, password = password),
    config = config(useragent = get_useragent())
  )

  if (res$status_code != 200) {
    stop(content(res)$error, call. = FALSE)
  }

  token <- content(res)$token
  if (is.null(token)) stop("something went wrong...")

  options(ImmPortToken = token, ImmPortTokenTime = Sys.time())

  token
}

#' @importFrom utils packageVersion
get_useragent <- function() {
  paste0(
    "R/", R.version$major, ".", R.version$minor,
    " (", Sys.info()["sysname"], " ", Sys.info()["machine"], ")",
    " ImmPortR/", packageVersion("ImmPortR")
  )
}
