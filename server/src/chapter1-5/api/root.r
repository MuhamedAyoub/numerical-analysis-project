
args <- commandArgs(trailingOnly = TRUE)

source(sprintf("%s/../logic/root.r", getwd()))
if (args[1] == "--json") {
  print(jsonlite::toJSON(intersections(jsonlite::parse_json(args[2]))$coords))
}
