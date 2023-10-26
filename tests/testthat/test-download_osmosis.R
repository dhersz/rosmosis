# if running manually, please run the following line first:
# source("tests/testthat/setup.R")

tester <- function(version = "0.48.3", force = FALSE, quiet = TRUE) {
  download_osmosis(version, force, quiet)
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

test_that("returns path to application with correct version", {
  output_path <- download_osmosis("0.48.3")

  expect_identical(list.files(rosmosis_cache), "osmosis-0.48.3")
  expect_true(fs::file_exists(output_path))

  sys_info <- Sys.info()
  if (sys_info["sysname"] == "Windows") {
    expect_true(grepl("osmosis\\.bat$", output_path))
  } else {
    expect_true(grepl("osmosis$", output_path))
  }
})

test_that("quiet argument is respected", {
  expect_silent(tester(quiet = TRUE))
  expect_message(tester(quiet = FALSE))

  expect_silent(tester(force = TRUE, quiet = TRUE))
  expect_message(tester(force = TRUE, quiet = FALSE))
})

test_that("force argument is respected", {
  expect_message(
    tester(force = FALSE, quiet = FALSE),
    class = "found_cached_osmosis"
  )

  expect_message(
    tester(force = TRUE, quiet = FALSE),
    class = "downloading_osmosis"
  )
})
