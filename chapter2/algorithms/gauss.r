gaussianEliminationTotalPivoting <- function(A, b) {
  n <- nrow(A)
  
  augmentedMatrix <- cbind(A, b)
  
  # Applying Gaussian elimination with total pivoting
  for (i in 1:(n - 1)) {
    # Total Pivoting
    pivotElement <- which.max(abs(augmentedMatrix[i:n, i:n]))
    pivotRow <- floor((pivotElement - 1) / (n - i + 1)) + i
    pivotCol <- pivotElement - (pivotRow - i) * (n - i + 1)
    
    if (pivotRow != i) {
      augmentedMatrix[c(i, pivotRow), ] <- augmentedMatrix[c(pivotRow, i), ]
    }
    if (pivotCol != i) {
      augmentedMatrix[, c(i, pivotCol)] <- augmentedMatrix[, c(pivotCol, i)]
    }
    
    # Elimination
    for (j in (i + 1):n) {
      factor <- augmentedMatrix[j, i] / augmentedMatrix[i, i]
      augmentedMatrix[j, ] <- augmentedMatrix[j, ] - factor * augmentedMatrix[i, ]
    }
  }
  
  # Back substitution
  x <- numeric(n)
  for (i in n:1) {
    x[i] <- (augmentedMatrix[i, n + 1] - sum(augmentedMatrix[i, (i + 1):n] * x[(i + 1):n])) / augmentedMatrix[i, i]
  }
  
  return(x)
}

gaussianEliminationPartialPivoting <- function(A, b) {
  n <- nrow(A)
  
  # Augmenting matrix [A|b]
  augmentedMatrix <- cbind(A, b)
  
  # Applying Gaussian elimination with partial pivoting
  for (i in 1:(n - 1)) {
    # Partial Pivoting
    pivotRow <- which.max(abs(augmentedMatrix[i:n, i])) + (i - 1)
    if (pivotRow != i) {
      augmentedMatrix[c(i, pivotRow), ] <- augmentedMatrix[c(pivotRow, i), ]
    }
    
    # Elimination
    for (j in (i + 1):n) {
      factor <- augmentedMatrix[j, i] / augmentedMatrix[i, i]
      augmentedMatrix[j, ] <- augmentedMatrix[j, ] - factor * augmentedMatrix[i, ]
    }
  }
  
  # Back substitution
  x <- numeric(n)
  for (i in n:1) {
    x[i] <- (augmentedMatrix[i, n + 1] - sum(augmentedMatrix[i, (i + 1):n] * x[(i + 1):n])) / augmentedMatrix[i, i]
  }
  
  return(x)
}

