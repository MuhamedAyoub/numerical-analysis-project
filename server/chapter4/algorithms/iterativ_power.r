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
    return(list(lambda = lambda, v = ceiling(v)))
}
your_matrix <- matrix(c(1, 2, 0, 2, 1, 0, 0, 0, -1), ncol = 3, byrow = TRUE)
result <- power_iteration(your_matrix)

cat("Lambda:", result$lambda, "\n")
cat("U:", result$v, "\n")
