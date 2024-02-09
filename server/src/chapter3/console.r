source(sprintf("%s/solve.r", getwd()))

args <- commandArgs(trailingOnly = TRUE)

vector <- sapply(strsplit(args[2], ";"), function(x) return(as.numeric(x)))

base <- rep(0, length(vector))
for (v in strsplit(args[1], ";")) {
  base <- rbind(
    base,
    sapply(strsplit(v, ","), function(x) return(as.numeric(x)))
  )
}

base <- base[2:length(base[, 1]), ]

result <- solvesys(base, vector, rep(0, length(vector)))
print(result)
print(paste(result$jacobi$result, collapse = ";"))
