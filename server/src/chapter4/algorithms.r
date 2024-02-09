# Power iteration Algorithm
power_iteration <- function(A, max_iter = 1000, tol = 1e-6) {
  n <- ncol(A)
  v <- matrix(rnorm(n), ncol = 1)
  for (iter in 1:max_iter) {
    Av <- A %*% v
    lambda <- sum(Av * v) / sum(v * v)
    v <- Av / sqrt(sum(Av * Av))
    if (iter > 1 && abs(lambda - old_lambda) < tol) {
      break
    }
    old_lambda <- lambda
  }

  return(list(lambda = lambda, v = v))
}

# Deflation method
deflation_method <- function(A, num_eigenvalues, max_iter = 1000, tol = 1e-6) {
  n <- ncol(A)
  eigenvalues <- numeric(num_eigenvalues)
  eigenvectors <- matrix(0, nrow = n, ncol = num_eigenvalues)

  for (i in 1:num_eigenvalues) {
    result <- power_iteration(A, max_iter, tol)
    eigenvalues[i] <- result$lambda
    eigenvectors[, i] <- result$v
    # Deflation step
    u <- matrix(eigenvectors[, i], nrow = n, ncol = 1) # Column vector
    v <- matrix(t(eigenvectors[, i]), nrow = 1, ncol = n) # Row vector
    A <- A - eigenvalues[i] * (u %*% t(v)) / (t(v) %*% u)
  }

  return(list(eigenvalues = eigenvalues, eigenvectors = eigenvectors))
}
givens_rotation <- function(A, max_iter = 1000, tol = 1e-6) {
  n <- ncol(A)
  G <- diag(1, n)

  for (iter in 1:max_iter) {
    max_off_diag <- max(abs(A[lower.tri(A)]))
    if (max_off_diag < tol) {
      break  # Convergence reached
    }

    indices <- which(abs(A) == max_off_diag, arr.ind = TRUE)
    p <- indices[1, 1]
    q <- indices[1, 2]

    theta <- atan2(A[q, q] - A[p, p], 2 * A[p, q])
    c <- cos(theta)
    s <- sin(theta)

    # Construct the rotation matrix
    G_pq <- diag(1, n)
    G_pq[c(p, q), c(p, q)] <- c(c, c)
    G_pq[p, q] <- -s
    G_pq[q, p] <- s

    # Compute t(G_pq) %*% A
    temp <- t(G_pq) %*% A
    
    # Compute A <- temp %*% G_pq
    A <- temp %*% G_pq
    
    # Update the matrix G
    G <- G %*% G_pq
  }

  return(list(eigenvalues = diag(A), eigenvectors = G))
}


getCompressedImage <- function(img_matrix, method_name, num_eigenvalues = 50) {
  svd_result =  svd(img_matrix)
  u =  svd_result$u
  sigma =  diag(svd_result$d)
  v  = svd_result$v
  rsponse = u %*% sigma %*% t(v)
  return (list(status="success", msg="Compressed Image", img_matrix = rsponse)) 
}
