context("aspera")

test_that("`list_immport` works", {
  skip_on_appveyor()

  res <- list_immport("/SDY1/StudyFiles")

  expect_is(res, "list")
  expect_equal(names(res), c("self", "items", "item_count", "total_count", "parameters"))

  expect_error(list_immport("/WrongPath"))
})

test_that("`download_immport` works", {
  skip_on_appveyor()

  file_path <- "/SDY1/StudyFiles/Casale_Study_Summary_Report.doc"
  temp_dir <- tempdir()

  res <- download_immport(path = file_path, output_dir = temp_dir)

  expect_is(res, "integer")
  expect_equal(res, 0)
  expect_true(basename(file_path) %in% dir(temp_dir))

  expect_error(download_immport("/WrongPath"))
})
