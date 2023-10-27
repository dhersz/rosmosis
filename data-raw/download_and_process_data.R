cur_osm <- osmextract::oe_match("Curitiba", quiet = TRUE)

pbf_path <- osmextract::oe_download(
  cur_osm$url,
  download_directory = tempdir(),
  quiet = TRUE
)

# some metalanguage going on here

output_path <- "inst/extdata/cur.osm.pbf"

osmosis_command <- paste0(
  "--read-pbf ", pbf_path, " ",
  "--bounding-box top=-25.4197 left=-49.2889 bottom=-25.4413 right=-49.2509 ",
  "completeWays=yes ",
  "--write-pbf ", output_path
)

osmosis_logs <- run_osmosis(
  osmosis_path(),
  osmosis_command
)
