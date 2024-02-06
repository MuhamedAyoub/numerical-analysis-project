# Taylor method of order p
taylorOrderP <- function(f, df, t0, y0, h, N, p) {
  # f: function representing the derivative dy/dt
  # df: list of functions representing the partial derivatives of f up to order p
  # t0, y0: initial values t(t0) = t0, y(t0) = y0
  # h: step size
  # N: maximum number of iterations
  # p: order of the Taylor method
  # Initialize arrays to store results
  t <- numeric(N + 1)
  y <- matrix(0, nrow = N + 1, ncol = length(y0))
  
  # Set initial values
  t[1] <- t0
  y[1, ] <- y0
  
  # Perform Taylor method of order p
  for (n in 1:N) {
    t[n + 1] <- t[n] + h
    y[n + 1, ] <- y[n, ]
    
    # Calculate the increment using Taylor series expansion
    for (k in 1:p) {
      y[n + 1, ] <- y[n + 1, ] + (h^k / factorial(k)) * df[[k]](t[n], y[n, ])
    }
    
    # Calculate next value of y using the increment
    y[n + 1, ] <- y[n + 1, ] + h * f(t[n], y[n, ])
  }
  
  # Return the results
  return(data.frame(t = t, y = y))
}

eulerExplicit <- function(f, a, b, y0, h) {
  # f: function representing the derivative dy/dx
  # a, b: interval [a, b] for solution
  # y0: initial value y(a)
  # h: step size
  
  N <- floor((b - a) / h)
  
  # Initialize arrays to store results
  x <- numeric(N + 1)
  y <- numeric(N + 1)
  
  # Set initial values
  x[1] <- a
  y[1] <- y0
  
  # Perform explicit Euler method
  for (n in 1:N) {
    x[n + 1] <- x[n] + h
    y[n + 1] <- y[n] + h * f(x[n], y[n])
  }
  
  # Return the results
  return(data.frame(x = x, y = y))
}

# Second-order Runge-Kutta method
rungeKutta2 <- function(f, x0, y0, h, N, alpha) {
  # f: function representing the derivative dy/dx
  # x0, y0: initial values (x0, y0)
  # h: step size
  # N: maximum number of iterations
  # alpha: parameter alpha
  
  # Initialize arrays to store results
  x <- numeric(N + 1)
  y <- numeric(N + 1)
  
  # Set initial values
  x[1] <- x0
  y[1] <- y0
  
  # Perform Runge-Kutta method of order 2
  for (n in 1:N) {
    x_half <- x[n] + alpha * h
    y_half <- y[n] + alpha * h * f(x[n], y[n])
    y[n + 1] <- y[n] + h * f(x_half, y_half)
    x[n + 1] <- x[n] + h
  }
  
  # Return the results
  return(data.frame(x = x, y = y))
}

# Fourth-order Runge-Kutta method
rungeKutta4 <- function(f, x0, y0, h, N) {
  # f: function representing the derivative dy/dx
  # x0, y0: initial values (x0, y0)
  # h: step size
  # N: maximum number of iterations
  
  # Initialize arrays to store results
  x <- numeric(N + 1)
  y <- numeric(N + 1)
  
  # Set initial values
  x[1] <- x0
  y[1] <- y0
  
  # Perform Runge-Kutta method of order 4
  for (n in 1:N) {
    k1 <- h * f(x[n], y[n])
    k2 <- h * f(x[n] + h/2, y[n] + k1/2)
    k3 <- h * f(x[n] + h/2, y[n] + k2/2)
    k4 <- h * f(x[n] + h, y[n] + k3)
    
    y[n + 1] <- y[n] + (k1 + 2*k2 + 2*k3 + k4) / 6
    x[n + 1] <- x[n] + h
  }
  
  # Return the results
  return(data.frame(x = x, y = y))
}
