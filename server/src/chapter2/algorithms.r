
gaussianEliminationTotalPivoting <- function(a_matrix, b_matrix) {
    # Write be as a matrix of col 1
    if (is.vector(b_matrix)) {
        b_matrix <- matrix(b_matrix, ncol = 1)
    }

  if(ncol(a_matrix) != nrow(b_matrix)) {
    stop("Error: rows in A is not equal to columns in B.\n")
  } else if(ncol(b_matrix) != 1 || nrow(b_matrix) != nrow(a_matrix)) {
    stop("Error: number of columns in B does not equal to one, or A is not square.\n")
  }

  # Creating the augmented matrix
  augmented_matrix <- cbind(a_matrix, b_matrix)

  n <- nrow(b_matrix)  # Number of rows

  for (i in 1:(n - 1)) {
    if (augmented_matrix[i, i] == 0) {
      stop("ERROR: null pivot number ", i, "\n")
      break
    } else {
      for (j in (i + 1):n) {
        if (augmented_matrix[j, i] != 0) {
          scalability_factor <- augmented_matrix[j, i] / augmented_matrix[i, i]
          for (k in 1:(n + 1)) {
            augmented_matrix[j, k] <- augmented_matrix[j, k] - augmented_matrix[i, k] * scalability_factor
          }
        }
      }
    }
  }


  # Back substitution to calculate variables x1, x2, x3
  variables <- rep(0, n)
  for (i in n:1) {
    variables[i] <- augmented_matrix[i, n + 1] / augmented_matrix[i, i]
    for (j in (i - 1):1) {
      augmented_matrix[j, n + 1] <- augmented_matrix[j, n + 1] - augmented_matrix[j, i] * variables[i]
    }
  }

    return(list(status="success",x=variables))

}

luDecompositionSolve <- function(A, B) {
  ## Start compute the execution time 
  # start_time = Sys.time()
  n <- nrow(A)
  m <- ncol(A)
  
  if (nrow(A) != ncol(A)) {
    return(list(status="error", msg="Matrix A must be square"))
  }
  
  lower <- matrix(0, n, n)
  upper <- matrix(0, n, n)
  Tol <- 1e-10  # Tolerance for division by zero

  for (i in 1:n) {
    for (k in i:m) {
      upper[i, k] <- A[i, k] - sum(lower[i, 1:(i - 1)] * upper[1:(i - 1), k])
    }
    
    for (k in i:n) {
      if (i == k) {
        lower[i, i] <- 1
      } else {
        if (abs(upper[i, i]) > Tol) {
          lower[k, i] <- (A[k, i] - sum(lower[k, 1:(i - 1)] * upper[1:(i - 1), i])) / upper[i, i]
        } else {
          # Handle division by zero (e.g., return error, set element to NA)
          warning("Division by zero encountered. Consider handling this case appropriately.")
          # Your custom handling logic here
        }
      }
    }
  }
  
  y <- numeric(n)
  for (i in 1:n) {
    y[i] <- (B[i] - sum(lower[i, 1:(i - 1)] * y[1:(i - 1)])) / lower[i, i]
  }
  
  # Ux = y (back substitution)
  x <- numeric(n)
  for (i in n:1) {
    if (i < n) {
      if (abs(upper[i, i]) > Tol) {
        x[i] <- (y[i] - sum(upper[i, (i + 1):n] * x[(i + 1):n])) / upper[i, i]
      } else {
        # Handle division by zero (e.g., return error, set element to NA)
        warning("Division by zero encountered. Consider handling this case appropriately.")
        # Your custom handling logic here
      }
    } else {
      x[i] <- y[i] / upper[i, i]
    }
  }
  # end_time = Sys.time() - start_time
  
  return(list(status="success", x=x, execution_time="Not supported in the web"))
}
choleskyDecompositionSolve <- function(A, B) {
  # start_time = Sys.time()

  n <- nrow(A)
  
  # Check if A is square and positive definite
  if (!all.equal(A, t(A))) {
    stop("Matrix A must be symmetric.")
  }
  if (any(eigen(A, symmetric = TRUE)$values <= 0)) {
    stop("Matrix A must be positive definite.")
  }
  
  # Cholesky decomposition
  L <- matrix(0, n, n)
  
  for (i in 1:n) {
    for (j in 1:i) {
      if (i == j) {
        L[i, i] <- sqrt(A[i, i] - sum(L[i, 1:(i-1)]^2))
      } else {
        L[i, j] <- (A[i, j] - sum(L[i, 1:(i-1)] * L[j, 1:(j-1)])) / L[j, j]
      }
    }
  }
  
  # Solving the system using Cholesky decomposition
  # Ly = B (forward substitution)
  y <- numeric(n)
  for (i in 1:n) {
    y[i] <- (B[i] - sum(L[i, 1:(i-1)] * y[1:(i-1)])) / L[i, i]
  }
  
  # Lt x = y (back substitution)
  x <- numeric(n)
  for (i in n:1) {  # Iterate from n down to 1 to avoid out-of-bounds issue
    if (i < n) {
      x[i] <- (y[i] - sum(L[(i+1):n, i] * x[(i+1):n])) / L[i, i]
    } else {
      x[i] <- y[i] / L[i, i]
    }
  } 
    # end_time = Sys.time() - start_time
  
  return(list(status="success", x=x, execution_time="Not supported on the web"))

  
}
gaussianEliminationPartialPivoting <- function(a_matrix, b_matrix) {
  # start_time = Sys.time()
    n <- nrow(a_matrix)
  augmented_matrix <- cbind(a_matrix, b_matrix)

  # Partial pivoting
  for (k in 1:(n - 1)) {
    max_index <- which.max(abs(augmented_matrix[k:n, k])) + k - 1
    augmented_matrix[c(k, max_index), ] <- augmented_matrix[c(max_index, k), ]

    if (augmented_matrix[k, k] == 0) {
      cat("IMPOSSIBLE: ", k, "-th pivot is zero. System may have no unique solution.\n")
      return(invisible())
    }

    # Forward elimination
    for (i in (k + 1):n) {
      scaling_factor <- augmented_matrix[i, k] / augmented_matrix[k, k]
      augmented_matrix[i, (k:n) + 1] <- augmented_matrix[i, (k:n) + 1] - scaling_factor * augmented_matrix[k, (k:n) + 1]
    }
  }

  cat("After forward elimination:\n")
  print(augmented_matrix)
  cat("\n")

  # Back-substitution
  x <- numeric(n)
  for (i in n:1) {
    x[i] <- augmented_matrix[i, n + 1] / augmented_matrix[i, i]
    augmented_matrix[1:(i - 1), n + 1] <- augmented_matrix[1:(i - 1), n + 1] - augmented_matrix[1:(i - 1), i] * x[i]
  }

  # end_time = Sys.time() - start_time
  
  return(list(status="success", x=x, execution_time="Not supported on the web"))
}

# Test the Algorithms on the console
A <- matrix(c(4, 12, -16, 12, 37, -43, -16, -43, 98), 3, 3)
B <- c(1, 2, 3)
print(gaussianEliminationTotalPivoting(a_matrix = A, b_matrix = B))

# print(luDecompositionSolve(A, B))
# print(choleskyDecompositionSolve(A, B))

## Defining the controller for the Chapter2 api

Ch2Controller <- function(A,B,selected_method) {
    if (selected_method == "Gauss") {
        gaussianEliminationPartialPivoting(a_matrix = A,b_matrix = B)
    } else if (selected_method == "LU") {
         luDecompositionSolve(A,B)
    } else if (selected_method == "Cholesky") {
        choleskyDecompositionSolve(A,B)
    } else {
        list(status="error", msg="Method not found")
    }
}