#' Get Osmosis path
#'
#' Returns the path to previously downloaded and cached Osmosis. If it has not
#' been downloaded yet, downloads it using [download_osmosis()].
#'
#' @param version A string. The version of Osmosis whose path should be
#'   returned. Defaults to `"0.48.3"`, the current latest version. Please check
#'   [openstreetmap/osmosis
#'   releases](https://github.com/openstreetmap/osmosis/releases/) for the full
#'   set of available versions.
#' @param force A logical. Passed to [download_osmosis()], whether to overwrite
#'   previously downloaded and cached Osmosis. Defaults to `FALSE`.
#' @param quiet A logical. Passed to [download_osmosis()], whether to hide
#'   informative messages or not. Defaults to `TRUE`.
#'
#' @return A string, the path to Osmosis.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' osmosis_path()
#'
#' @export
osmosis_path <- function(version = "0.48.3", force = FALSE, quiet = TRUE) {
  checkmate::assert_string(version)
  checkmate::assert_logical(force, any.missing = FALSE, len = 1)
  checkmate::assert_logical(quiet, any.missing = FALSE, len = 1)

  rosmosis_cache <- tools::R_user_dir("rosmosis", which = "cache")

  cache_dir <- file.path(rosmosis_cache, paste0("osmosis-", version))

  sys_info <- Sys.info()
  ext <- if (sys_info["sysname"] == "Windows") ".bat" else ""
  osmosis_file <- file.path(cache_dir, "bin", paste0("osmosis", ext))

  if (!fs::file_exists(osmosis_file) || force) {
    download_osmosis(version, force, quiet)
  }

  return(osmosis_file)
}
