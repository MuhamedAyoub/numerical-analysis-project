# points should b x0,y0;x1,y1;...
args <- commandArgs(trailingOnly = TRUE)

points <- matrix(c(1, 1), nrow = 2)
for (point in strsplit(args[1], ";")) {
  points <- cbind(points, sapply(strsplit(point, ","), as.numeric))
}

points <- points[, 2:length(points[1, ])]
print(paste(interpolate(points), collapse = ";"))
