#' @importFrom httr POST content
get_token <- function(username, password) {
  res <- POST(
    url = "https://auth.immport.org/auth/token",
    body = list(username = username, password = password)
  )

  if (res$status_code == 200) {
    content(res)$token
  } else {
    stop(content(res)$error, call. = FALSE)
  }
}
