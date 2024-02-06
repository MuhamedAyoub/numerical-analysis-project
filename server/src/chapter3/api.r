library(plumber)
plumb("solve.r") %>%
  pr_run(port = 3001)
