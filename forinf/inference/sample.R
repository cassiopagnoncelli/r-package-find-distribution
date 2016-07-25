source('infer.R')

# Dataset.
x1 <- rnorm(500, mean=10, sd=2)
x2 <- rpois(500, lambda=25)
y  <- (x2/(x1 + x2*sqrt(x1)))^(-1)

# Infer the formula.
formula_find(y, x1, x2)
