luDecomposition <- function(mat) {
  n <- nrow(mat)
  
  lower <- matrix(0, n, n)
  upper <- matrix(0, n, n)
  
  for (i in 1:n) {
    # Upper Triangular
    for (k in i:n) {
      # Summation of L(i, j) * U(j, k)
      sum_val <- sum(lower[i, 1:(i-1)] * upper[1:(i-1), k])
      # Evaluating U(i, k)
      upper[i, k] <- mat[i, k] - sum_val
    }
    
    # Lower Triangular
    for (k in i:n) {
      if (i == k) {
        lower[i, i] <- 1  # Diagonal as 1
      } else {
        # Summation of L(k, j) * U(j, i)
        sum_val <- sum(lower[k, 1:(i-1)] * upper[1:(i-1), i])
        # Evaluating L(k, i)
        lower[k, i] <- (mat[k, i] - sum_val) / upper[i, i]
      }
    }
  }
  
  cat("Lower Triangular\t\tUpper Triangular\n")
  
  # Displaying the result
  for (i in 1:n) {
    # Lower
    cat(paste(lower[i, ], collapse = "\t"), "\t")
    
    # Upper
    cat(paste(upper[i, ], collapse = "\t"), "\n")
  }
}

# Driver code
mat <- matrix(c(2, -1, -2, -4, 6, 3, -4, -2, 8), 3, 3, byrow = TRUE)

luDecomposition(mat)