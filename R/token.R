#' @importFrom httr POST content
get_token <- function(username = getOption("ImmPortUsername"),
                      password = getOption("ImmPortPassword")) {
  if (is.null(username)) stop("set username")
  if (is.null(password)) stop("set password")

  if (!is.null(getOption("ImmPortToken"))) {
    if (difftime(Sys.time(), getOption("ImmPortTokenTime"), units = "secs") < 50) {
      return(getOption("ImmPortToken"))
    }
  }

  res <- POST(
    url = "https://auth.immport.org/auth/token",
    body = list(username = username, password = password)
  )

  if (res$status_code != 200) {
    stop(content(res)$error, call. = FALSE)
  }

  token <- content(res)$token
  if (is.null(token)) stop("something went wrong...")

  options(ImmPortToken = token, ImmPortTokenTime = Sys.time())

  token
}
