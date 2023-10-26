# if running manually, please run the following line first:
# source("tests/testthat/setup.R")

tester <- function(version = "0.48.3", force = FALSE, quiet = TRUE) {
  osmosis_path(version, force, quiet)
}

test_that("input should be correct", {
  expect_error(tester(0.48))
  expect_error(tester(c("0.48.3", "0.48.3")))

  expect_error(tester(force = 0))
  expect_error(tester(force = NA))
  expect_error(tester(force = c(TRUE, TRUE)))

  expect_error(tester(quiet = 0))
  expect_error(tester(quiet = NA))
  expect_error(tester(quiet = c(TRUE, TRUE)))
})

testthat::skip_on_cran()

expected_path <- download_osmosis("0.48.3")

test_that("returns path to application with correct version", {
  output_path <- tester("0.48.3")

  expect_identical(output_path, expected_path)
})

test_that("downloads osmosis if not previously cached or if force = TRUE", {
  clear_cache()
  expect_message(
    output_path <- tester(quiet = FALSE),
    class = "downloading_osmosis"
  )
  expect_identical(output_path, expected_path)

  expect_message(
    output_path <- tester(force = TRUE, quiet = FALSE),
    class = "downloading_osmosis"
  )
  expect_identical(output_path, expected_path)
})
