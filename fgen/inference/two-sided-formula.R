options(warn=-1)

# Dataset.
x1 <- rnorm(500, mean=10, sd=2)
x2 <- rpois(500, lambda=25)
y  <- (x2/(x1 + x2*sqrt(x1)))^(-1)

# Evaluate formulas and calculate errors.
formulas <- system("sh filter.sh < ar-2.txt", T)
errors <- c()
for (i in seq(1, length(formulas))) {
  errors <- c(
    errors,
    sqrt(sum((y - eval(parse(text=formulas[i])))^2)) / length(y)
  )
}

# Display the results.
results <- data.frame(formula=formulas, err=errors)
results <- results[order(results[,'err']),]
row.names(results) <- NULL

form <- results[1, 'formula']
err <- results[1, 'err']
if (abs(err) < 1e-6) {
  cat(paste("Found the formula: ", form))
} else
  cat(paste("Couldn't find exact formula, but found a decent approximation: ", form))
