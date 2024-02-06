api_file = file.path(getwd(), "server/api.r")
library(plumber)


r<-plumb(api_file)$run(port=8002)