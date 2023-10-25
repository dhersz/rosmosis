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
  sys_info <- Sys.info()
  ext <- if (sys_info["sysname"] == "Windows") ".bat" else ""

  release_download_url <- paste0(
    "https://github.com/openstreetmap/osmosis/releases/download/",
    version
  )
  zip_url <- paste0(release_download_url, "/osmosis-", version, ".zip")

  tmpfile <- tempfile("osmosis", fileext = ".zip")
  utils::download.file(zip_url, destfile = tmpfile, quiet = quiet)

  tmpdir <- tempfile("osmosis")
  zip::unzip(tmpfile, exdir = tmpdir)

  osmosis_file <- file.path(tmpdir, "bin", paste0("osmosis", ext))

  cache_dir <- tools::R_user_dir("rosmosis", which = "cache")
  if (!dir.exists(cache_dir)) dir.create(cache_dir, recursive = TRUE)

  cache_file <- file.path(cache_dir, paste0("osmosis_", version, ext))
  invisible(file.copy(osmosis_file, cache_file))

  return(invisible(cache_file))
}
