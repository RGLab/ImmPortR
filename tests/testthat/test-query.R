context("query")

test_that("`query_dataset` works", {
  res <- query_dataset("elisa", "SDY269")

  expect_is(res, "data.frame")
  expect_length(res, 41)

  expect_error(query_dataset("invalidDataset", "SDY269"))
})

test_that("`query_filePath` works", {
  res <- query_filePath("SDY269")

  expect_is(res, "data.frame")
  expect_length(res, 37)
})
