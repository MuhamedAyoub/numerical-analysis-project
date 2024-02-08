
source("./interpolate.r")

#* @param objects an array of objects to process
#* @serializer contentType list(type="text/plain")
#* @post /chapter1_5
function(objects) {
  objects <- jsonlite::parse_json(objects)
  middle(objects)
}
