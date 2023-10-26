#' Download Osmosis
#'
#' Downloads Osmosis, a command-line application for processing OpenStreetMap
#' data.
#'
#' @param version A string. The version of Osmosis to be downloaded. Defaults to
#'   `"0.48.3"`, the current latest version. Please check [openstreetmap/osmosis
#'   releases](https://github.com/openstreetmap/osmosis/releases/) for the full
#'   set of available versions.
#' @param force A logical. Whether to overwrite previously downloaded and cached
#'   Osmosis. Defaults to `FALSE`.
#' @param quiet A logical. Whether to hide informative messages or not. Defaults
#'   to `TRUE`.
#'
#' @return Invisibly returns the path to Osmosis.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' download_osmosis()
#'
#' @export
download_osmosis <- function(version = "0.48.3",
                             force = FALSE,
                             quiet = TRUE) {
  checkmate::assert_string(version)
  checkmate::assert_logical(force, any.missing = FALSE, len = 1)
  checkmate::assert_logical(quiet, any.missing = FALSE, len = 1)

  # we first check if osmosis has been previously downloaded and cached, in
  # which case we skip the whole downloading/unziping/moving process. if it has
  # not been downloaded before, or if 'force = TRUE', we download it.

  rosmosis_cache <- tools::R_user_dir("rosmosis", which = "cache")

  cache_dir <- file.path(rosmosis_cache, paste0("osmosis-", version))

  sys_info <- Sys.info()
  ext <- if (sys_info["sysname"] == "Windows") ".bat" else ""
  osmosis_file <- file.path(cache_dir, "bin", paste0("osmosis", ext))

  if (fs::file_exists(osmosis_file) && !force) {
    if (!quiet) cached_osmosis_message()
  } else {
    release_download_url <- paste0(
      "https://github.com/openstreetmap/osmosis/releases/download/",
      version
    )
    zip_url <- paste0(release_download_url, "/osmosis-", version, ".zip")

    tmpfile <- tempfile("osmosis", fileext = ".zip")

    if (!quiet) downloading_osmosis_message(zip_url)

    request <- httr2::request(zip_url)
    invisible(httr2::req_perform(request, path = tmpfile))

    tmpdir <- file.path(tempdir(), paste0("osmosis-", version))
    zip::unzip(tmpfile, exdir = tmpdir)

    fs::dir_create(rosmosis_cache, recurse = TRUE)
    if (fs::dir_exists(cache_dir)) fs::dir_delete(cache_dir)
    fs::dir_copy(tmpdir, rosmosis_cache)
  }

  return(invisible(osmosis_file))
}

cached_osmosis_message <- function() {
  message(
    rlang::message_cnd(
      class = "found_cached_osmosis",
      message = "Returning path to Osmosis previously downloaded and cached."
    )
  )
}

downloading_osmosis_message <- function(zip_file, tmpfile) {
  message(
    rlang::message_cnd(
      class = "downloading_osmosis",
      message = paste0("Downloading Osmosis zip file (", zip_file, ").")
    )
  )
}

# test_query <- c(
#   "--read-pbf", "data_test/geofabrik_new-york-latest.osm.pbf",
#   "--tag-filter", "accept-ways",
#   "highway=*", "park_ride=*",
#   "public_transport=platform", "railway=platform",
#   "--tag-filter", "accept-relations",
#   "type=restriction",
#   "--used-node",
#   "--write-pbf", "data_test/filtered-geofabrik_new-york-latest.osm.pbf"
# )
# processx::run(osmosis_path(), args = test_query)
