context("token")

test_that("`get_token` works", {
  token <- ImmPortR:::get_token()

  expect_is(token, "character")
  expect_match(token, "\\S+")
})
