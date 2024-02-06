

RK4 <- function(t, y, h, f) {
  k1 <- f(t, y)
  k2 <- f(t + h/2, y + h/2 * k1)
  k3 <- f(t + h/2, y + h/2 * k2)
  k4 <- f(t + h, y + h * k3)
  
  return(1/6 * (k1 + 2 * k2 + 2 * k3 + k4))
}
RHS <- function(t, y) {
  g <- 9.8
  l1 <- 1
  l2 <- 1
  m1 <- 1
  m2 <- 1
  w1 <- 0
  w2 <- 0
  theta_1 <- y[1]
  theta_2 <- y[2]
  delta_theta <- theta_1 - theta_2
  
  f0 <- w1
  f1 <- w2
  
  f2 <- (m2*l1*w1^2*sin(2*delta_theta) + 2*m2*l2*w2^2*sin(delta_theta) + 2*g*m2*cos(theta_2)*sin(delta_theta) + 2*g*m1*sin(theta_1))/(-2*l1*(m1 + m2*sin(delta_theta)^2))
  
  f3 <- (m2*l2*w2^2*sin(2*delta_theta) + 2*(m1 + m2)*l1*w1^2*sin(delta_theta) + 2*g*(m1 + m2)*cos(theta_1)*sin(delta_theta))/(2*l2*(m1 + m2*sin(delta_theta)^2))
  
  return(c(f0, f1, f2, f3))
}
getPalindMatrix <- function() {
  t0 <- 0 
  T <- 100
  n <- 2048
  
  # Initial conditions
  y0 <- c(pi/4, pi/4, 0, 0)
  
  # Domain discretization
  t_n <- seq(t0, T, length.out = n) 
  y_n <- matrix(y0, nrow = length(y0), ncol = n)
  
  # Step size
  h <- (T - t0)/n
  
  # Initialize data frame to store results
  results <- data.frame(t = numeric(), theta1 = numeric(), theta2 = numeric(), stringsAsFactors = F)
  
  while (tail(t_n, 1) < T) {
    # Keep going until T is reached.
    # Store numerical solutions into y_n
    new_y <- y_n[, ncol(y_n)] + h * RK4(t_n[length(t_n)], y_n[, ncol(y_n)], h, RHS)
    y_n <- cbind(y_n, new_y)
    t_n <- c(t_n, tail(t_n, 1) + h)
    
    # Append results to data frame
    results <- dplyr::bind_rows(results, data.frame(t = tail(t_n, 1), theta1 = new_y["theta1"], theta2 = new_y["theta2"]))

  }

df <- as.data.frame(t(y_n))
names(df) <- c("theta1", "theta2", "w1", "w2")

df$t <- t_n

return (list(results = results, df = df))
}

