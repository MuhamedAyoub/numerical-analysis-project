# points should b x0,y0;x1,y1;...
args <- commandArgs(trailingOnly = TRUE)

source("../logic/interpolate.r")
if (length(args) == 0) {
  middle(jsonlite::read_json("../sample/query.json"))
}
if (args[1] == "--json") {
  jsonlite::toJSON(middle(jsonlite::parse_json(args[2])))
} else {
  middle(jsonlite::read_json(args[1]))
}
