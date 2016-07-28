source('formula-finder.R')
source('model-finder.R')

# Dataset.
x1 <- rnorm(500, mean=10, sd=2)
x2 <- rpois(500, lambda=10)
y  <- (x2/(x1 + x2*sqrt(x1)))^(-1)
y <- sqrt(x1^2+x2^2)

# Infer formula.
formula_find(y, x1, x2)

# Infer model.
model_find(y, x1, x2)
