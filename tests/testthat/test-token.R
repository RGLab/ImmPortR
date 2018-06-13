context("token")

options(ImmPortUsername = Sys.getenv("ImmPortUsername"))
options(ImmPortPassword = Sys.getenv("ImmPortPassword"))

test_that("`get_token` works", {
  token <- ImmPortR:::get_token(
    username = getOption("ImmPortUsername"),
    password = getOption("ImmPortPassword")
  )

  expect_is(token, "character")
  expect_match(token, "\\S+")
})
