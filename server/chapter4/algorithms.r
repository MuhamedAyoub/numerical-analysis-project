# Power iteration Algorithms
power_iteration <- function(A, max_iter = 1000, tol = 1e-6) {
    n <- ncol(A)
    v <- matrix(rnorm(n), ncol = 1)
    # iterations ..
    for (iter in 1:max_iter) {
        Av <- A %*% v
        lambda <- sum(Av * v) / sum(v * v)
        v <- Av / sqrt(sum(Av * Av))
        if (iter > 1 && abs(lambda - old_lambda) < tol) {
            break
        }
        old_lambda <- lambda
    }

    # Return The lambda value and  Vector U
    # you can return the real value of U by removing ceiling function
    return(list(lambda = lambda, v = v))
}


# Méthode de déflation

deflation_method <- function(A, num_eigenvalues, max_iter = 1000, tol = 1e-6) {
  n <- ncol(A)
  eigenvalues <- numeric(num_eigenvalues)
  eigenvectors <- matrix(0, nrow = n, ncol = num_eigenvalues)

  for (i in 1:num_eigenvalues) {
    result <- power_iteration(A, max_iter, tol)
    eigenvalues[i] <- result$lambda
    eigenvectors[, i] <- result$v
    # Deflation step
    A <- A - eigenvalues[i] * (eigenvectors[, i] %*% t(eigenvectors[, i])) / (t(eigenvectors[, i]) %*% eigenvectors[, i] )
  }

  return(list(eigenvalues = eigenvalues, eigenvectors = eigenvectors))
}

# Méthode de Jacobi et Rotations de Givens
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

    # Compute the rotation angle and sine/cosine values
    theta <- atan2(A[q, q] - A[p, p], 2 * A[p, q])
    c <- cos(theta)
    s <- sin(theta)

    # Construct the rotation matrix
    G_pq <- diag(1, n)
    G_pq[c(p, q), c(p, q)] <- c(c, c)
    G_pq[p, q] <- -s
    G_pq[q, p] <- s

    # Update the matrices A and G
    A <- t(G_pq) %*% A %*% G_pq
    G <- G %*% G_pq
  }

  return(list(eigenvalues = diag(A), eigenvectors = G))
}
