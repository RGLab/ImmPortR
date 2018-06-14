context("query")

options(ImmPortUsername = Sys.getenv("ImmPortUsername"))
options(ImmPortPassword = Sys.getenv("ImmPortPassword"))

test_that("`query_dataset` works", {
  res <- query_dataset(dataset = "elisa", study = "SDY269")

  expect_is(res, "data.frame")
  expect_length(res, 41)
})
