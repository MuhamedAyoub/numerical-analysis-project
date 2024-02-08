library(plumber)

pr("./api/api.r") %>%
  pr_run(port = 3001)
