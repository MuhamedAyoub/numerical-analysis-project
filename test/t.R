library(deSolve)
library(ggplot2)
library(animation)

# =============================================================================
# globals
# =============================================================================
m1 <- 1  # mass of the 1st pendulum
m2 <- 1  # mass of the 2nd pendulum
g <- 10  # gravity
r1 <- 1  # length of the 1st pendulum
r2 <- 1  # length of the 2nd pendulum

angular_acc1 <- function(a1_arr, a2_arr) {
  num <- (
    -g * (2 * m1 + m2) * sin(a1_arr[1])
    - m2 * g * sin(a1_arr[1] - 2 * a2_arr[1])
    - 2
    * m2
    * sin(a1_arr[1] - a2_arr[1])
    * (
      r2 * a2_arr[2]^2
      + r1 * a1_arr[2]^2 * cos(a1_arr[1] - a2_arr[1])
    )
  )
  den <- r1 * (2 * m1 + m2 - m2 * cos(2 * a1_arr[1] - 2 * a2_arr[1]))
  return(num / den)
}

angular_acc2 <- function(a1_arr, a2_arr) {
  temp <- 2 * sin(a1_arr[1] - a2_arr[1])
  num <- temp * (
    r1 * a1_arr[2]^2 * (m1 + m2)
    + g * (m1 + m2) * cos(a1_arr[1])
    + r2 * a2_arr[2]^2 * m2 * cos(a1_arr[1] - a2_arr[1])
  )
  den <- r2 * (2 * m1 + m2 - m2 * cos(2 * a1_arr[1] - 2 * a2_arr[1]))
  return(num / den)
}

# RK4 method
rk4 <- function(t, y, dt, derivs) {
  k1 <- dt * derivs(t, y)
  k2 <- dt * derivs(t + dt / 2, y + k1 / 2)
  k3 <- dt * derivs(t + dt / 2, y + k2 / 2)
  k4 <- dt * derivs(t + dt, y + k3)
  return(y + (k1 + 2 * k2 + 2 * k3 + k4) / 6)
}

# Derivatives
derivs <- function(t, y) {
  a1_arr <- c(y[1], y[2])
  a2_arr <- c(y[3], y[4])
  return(c(y[2], angular_acc1(a1_arr, a2_arr), y[4], angular_acc2(a1_arr, a2_arr)))
}

# Initial conditions
y <- c(pi/2, 0, pi/2, 1)
t <- 0
dt <- 0.001
steps_no <- 100000

# Arrays to store the results
pendulum1_theta <- pendulum1_angular_speed <- numeric(steps_no)
pendulum2_theta <- pendulum2_angular_speed <- numeric(steps_no)

# RK4 integration loop
for (i in 1:steps_no) {
  y <- rk4(t, y, dt, derivs)
  t <- t + dt
  pendulum1_theta[i] <- y[1]
  pendulum1_angular_speed[i] <- y[2]
  pendulum2_theta[i] <- y[3]
  pendulum2_angular_speed[i] <- y[4]
}

# Convert to Cartesian coordinates
pendulum1_x <- r1 * sin(pendulum1_theta)
pendulum1_y <- -r1 * cos(pendulum1_theta)
pendulum2_x <- r2 * sin(pendulum2_theta) + pendulum1_x
pendulum2_y <- pendulum1_y - r2 * cos(pendulum2_theta)

# You can plot the pendulum's position or angular speed/acceleration as a function of time
# For example, to plot the position of the first pendulum:
df <- data.frame(Time = times, X = pendulum1_x, Y = pendulum1_y)
ggplot(df, aes(x = X, y = Y)) +
  geom_path() +
  labs(x = "X Position", y = "Y Position", title = "Position of the First Pendulum Over Time")
