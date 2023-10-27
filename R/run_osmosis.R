#' Run Osmosis
#'
#' Runs Osmosis, given the path to the application and the commands that should
#' be sent to the command-line tool.
#'
#' @param osmosis_path A string. The path to Osmosis.
#' @param command A string. The command to run.
#' @param echo A logical. Whether to print the standard output and error to the
#'   screen. Defaults to `TRUE`.
#' @param spinner A logical. Whether to show a reassuring spinner while the
#'   process is running. Defaults to `TRUE`.
#'
#' @return Invisibly returns a list containing the exit status of the Osmosis
#'   process, the standard output of the command, the standard error of the
#'   command and whether the process was killed due to a timeout.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' cur_osm <- system.file("extdata/cur.osm.pbf", package = "rosmosis")
#'
#' fs::file_size(cur_osm)
#'
#' # cropping the pbf using a bounding box
#'
#' output_path <- tempfile("cropped_cur", fileext = ".osm.pbf")
#'
#' osmosis_command <- paste0(
#'   "--read-pbf ", cur_osm, " ",
#'   "--bounding-box ",
#'   "top=-25.4290 left=-49.2792 bottom=-25.4394 right=-49.2629 ",
#'   "completeWays=yes ",
#'   "--write-pbf ", output_path
#' )
#'
#' run_osmosis(osmosis_path(), osmosis_command, echo = FALSE, spinner = FALSE)
#' fs::file_size(output_path)
#'
#' @export
run_osmosis <- function(osmosis_path, command, echo = TRUE, spinner = TRUE) {
  checkmate::assert_file_exists(osmosis_path)
  checkmate::assert_string(command)
  checkmate::assert_logical(echo, any.missing = FALSE, len = 1)
  checkmate::assert_logical(spinner, any.missing = FALSE, len = 1)

  args <- unlist(strsplit(command, " "))

  logs <- processx::run(osmosis_path, args, echo = echo, spinner = spinner)

  return(invisible(logs))
}
