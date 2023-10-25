#' Download Osmosis
#'
#' Download Osmosis.
#'
#' @param version A string. Osmosis version.
#' @param quiet A logical. Whether to display informative messages or not
#'   (defaults to `FALSE`).
#'
#' @return Invisibly returns the path to the downloaded Osmosis file.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' download_osmosis()
#'
#' @export
download_osmosis <- function(version = "0.48.3", quiet = TRUE) {
  release_download_url <- paste0(
    "https://github.com/openstreetmap/osmosis/releases/download/",
    version
  )
  zip_url <- paste0(release_download_url, "/osmosis-", version, ".zip")

  tmpfile <- tempfile("osmosis", fileext = ".zip")
  utils::download.file(zip_url, destfile = tmpfile, quiet = quiet)

  tmpdir <- file.path(tempdir(), paste0("osmosis-", version))
  zip::unzip(tmpfile, exdir = tmpdir)
  
  rosmosis_cache <- tools::R_user_dir("rosmosis", which = "cache")
  if (!dir.exists(rosmosis_cache)) dir.create(rosmosis_cache, recursive = TRUE)
  
  cache_dir <- file.path(rosmosis_cache, paste0("osmosis-", version))
  invisible(file.copy(tmpdir, rosmosis_cache, recursive = TRUE))

  sys_info <- Sys.info()
  ext <- if (sys_info["sysname"] == "Windows") ".bat" else ""
  osmosis_file <- file.path(cache_dir, "bin", paste0("osmosis", ext))

  return(invisible(osmosis_file))
}

osmosis_path <- function(version = "0.48.3", quiet = TRUE) {
  rosmosis_cache <- tools::R_user_dir("rosmosis", which = "cache")
  
  cache_dir <- file.path(rosmosis_cache, paste0("osmosis-", version))
  
  osmosis_file <- if (dir.exists(cache_dir)) {
    sys_info <- Sys.info()
    ext <- if (sys_info["sysname"] == "Windows") ".bat" else ""
    file.path(cache_dir, "bin", paste0("osmosis", ext))
  } else {
    download_osmosis(version, quiet)
  }
  
  return(osmosis_file)
}

test_query <- c(
  "--read-pbf", "data_test/geofabrik_new-york-latest.osm.pbf",
  "--tag-filter", "accept-ways",
  "highway=*", "park_ride=*",
  "public_transport=platform", "railway=platform",
  "--tag-filter", "accept-relations",
  "type=restriction",
  "--used-node",
  "--write-pbf", "data_test/filtered-geofabrik_new-york-latest.osm.pbf"
)
processx::run(osmosis_path(), args = test_query)
