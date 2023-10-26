rosmosis_cache <- tools::R_user_dir("rosmosis", which = "cache")

clear_cache <- function() {
  if (fs::dir_exists(rosmosis_cache)) fs::dir_delete(rosmosis_cache)

  return(invisible(TRUE))
}
