# points should b x0,y0;x1,y1;...
args <- commandArgs(trailingOnly = TRUE)

source("./interpolate.r")
middle(jsonlite::read_json(if (length(args) > 1) args[1] else "query.json"))
