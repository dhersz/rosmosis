# if running manually, please run the following line first:
# source("tests/testthat/setup.R")

path <- osmosis_path()

cur_osm <- system.file("extdata/cur.osm.pbf", package = "rosmosis")
output_path <- tempfile("cropped_cur", fileext = ".osm.pbf")
osmosis_command <- paste0(
  "--read-pbf ", cur_osm, " ",
  "--bounding-box ",
  "top=-25.4290 left=-49.2792 bottom=-25.4394 right=-49.2629 ",
  "completeWays=yes ",
  "--write-pbf ", output_path
)

tester <- function(osmosis_path = path,
                   command = osmosis_command,
                   echo = TRUE,
                   spinner = TRUE) {
  run_osmosis(osmosis_path, command, echo, spinner)
}

test_that("input should be correct", {
  expect_error(tester(1))
  expect_error(tester("a"))

  expect_error(tester(command = 0))
  expect_error(tester(command = c("oi", "oi")))

  expect_error(tester(echo = 0))
  expect_error(tester(echo = NA))
  expect_error(tester(echo = c(TRUE, TRUE)))

  expect_error(tester(spinner = 0))
  expect_error(tester(spinner = NA))
  expect_error(tester(spinner = c(TRUE, TRUE)))
})

testthat::skip_on_cran()

test_that("returns list with process information on success", {
  process_info <- tester(echo = FALSE, spinner = FALSE)

  expect_type(process_info, "list")
  expect_type(process_info$status, "integer")
  expect_type(process_info$stdout, "character")
  expect_type(process_info$stderr, "character")
  expect_type(process_info$timeout, "logical")
})

test_that("raises error on failure", {
  expect_error(tester(command = "a", echo = FALSE, spinner = FALSE))
})
