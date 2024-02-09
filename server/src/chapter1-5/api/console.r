# points should b x0,y0;x1,y1;...
args <- commandArgs(trailingOnly = TRUE)

current <- getwd()
source(sprintf("%s/../logic/interpolate.r", current))
if (length(args) == 0) {
  middle(jsonlite::read_json(sprintf("%s/../sample/query.json", current)))
}
if (args[1] == "--json") {
  jsonlite::toJSON(middle(jsonlite::parse_json(args[2])))
} else {
  middle(jsonlite::read_json(args[1]))
}
