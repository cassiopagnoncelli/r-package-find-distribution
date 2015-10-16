#
# Find the distribution of a given set.
#
# Idea:
# 1. Extend the dataset with bootstrap if it is too small
# 2. Classify the data (eg. real or nonnegative or positive, integer or continuous
# 3. Find the best parameters for each distribution
# 4. List the distributions with the best fitting ranked by the most likely distributions
#

# TODO
# 1. include parameters restrictions in rmse, eg. a < b in runif.
# 2. solve the warnings().
#

library('compiler')
library('pso')
library('GenSA')

#options(error = recover)



# Summarizes the dataset.
dataSummary <- function(x) {
  # Completeness
  is_complete <- sum(is.na(x)) == 0 & sum(is.nan(x)) == 0
  x <- x[!is.na(x) && !is.nan(x)]
  
  # Basic summary
  min_x <- min(x)
  max_x <- max(x)
  
  # Type
  is_discrete <- sum(x - as.integer(x)) == 0
  
  # Domain
  has_negative <- min_x < 0
  has_zero <- sum(x == 0) > 0
  has_positive <- max_x > 0
  domain <- switch((2^0)*has_negative + (2^1)*has_zero + (2^2)*has_positive,
                   'NEGATIVE',
                   'NOT_IDENTIFIED',
                   'NONPOSITIVE',
                   'POSITIVE',
                   'REAL',
                   'NONNEGATIVE',
                   'REAL')
  
  # Return
  list(is_complete = is_complete,
       is_discrete = is_discrete,
       domain = domain)
}

# Pdf and pmf database.
pfDB <- data.frame(name=c(), pf=c(), discrete=c(), domain=c(), exotic=c())
pfParamsDB <- list()

insertPF <- function(name, pf, discrete, domain, params, exotic=TRUE) {
  row <- data.frame(name=name, pf=pf, discrete=discrete, domain=domain, exotic=exotic)
  assign('pfDB', rbind(pfDB, row), envir=.GlobalEnv)
  assign(paste("pfParamsDB$", pf, sep=""), params, envir=.GlobalEnv)
}

inf <- 2^16

# Find the most fit distributions for the given data.
findDistribution <- function(x, include.exotics=FALSE) {
  # Key data information.
  ds <- dataSummary(x)
  
  # List pmf/pdf candidates.
  candidates <- pfDB[pfDB$discrete == ds$is_discrete,]
  if (!include.exotics)
    candidates <- candidates[candidates$exotic == FALSE,]
  
  # Estimate probability density/mass function.
  if (ds$is_discrete) {                             ################ FIXME ##############
    f <- hist(x, breaks=(min(x)-0.5):(max(x)+0.5), plot=F)
    f.x <- f$mids
    f.y <- f$density
  } else {
    f <- density(x, from=min(x), to=max(x))
    f.x <- f$x
    f.y <- f$y
  }
  
  # Perform optimization across candidates
  ranking <- data.frame(pf=c(), error=c())
  best_params <- list()
  for (i in 1:nrow(candidates)) {
    candidate <- candidates[i,]
    
    cat(paste("Testing", candidate$name, "distribution... "))
    
    params_meta <- get(paste('pfParamsDB$', candidate$pf, sep=''))
    
    conv.params <- cmpfun(function(params) {
      b <- as.logical(params_meta$discrete)
      for (i in 1:length(params))
        if (b[i])
          params[i] <- round(params[i])
      
      return(params)
    })
    
    rmse <- cmpfun(function(params) {
      sqrt(sum((do.call(
        as.character(candidate$pf),
        append(list(f.x), as.list(conv.params(params)))) - f.y)^2))
    })
    
    if (sum(params_meta$discrete) > 0) {
      o <- GenSA(params_meta$initial, rmse,
                 lower=params_meta$min, upper=params_meta$max,
                 control=list(maxit=3000))
    } else {
      o <- optim(params_meta$initial, rmse,
                 lower=params_meta$min, upper=params_meta$max, method='L-BFGS-B',
                 control=list())
    }
    
    ranking <- rbind(ranking, data.frame(pf=candidate$pf, error=o$value))
    best_params[[as.character(candidate$pf)]] <- conv.params(o$par)
    
    if (o$counts[1] <= 2)
      print(o)
    
    cat("OK\n")
  }
  
  ranking <- ranking[order(ranking$error),]
  
  list(params=best_params, ranking=ranking)
}

#
# PMF and PDF database.
#

# Continuous
insertPF('normal', 'dnorm', FALSE, 'REAL', 
         data.frame(
           name=c('mean', 'sd'),
           min=c(-inf, 0),
           max=c(inf, inf),
           discrete=c(FALSE, FALSE),
           initial=c(0, 1)),
         FALSE)

insertPF('log-normal', 'dlnorm', FALSE, 'NONNEGATIVE',
         data.frame(
           name=c('mean', 'sd'),
           min=c(0, 0),
           max=c(inf, inf),
           discrete=c(FALSE, FALSE),
           initial=c(1, 1)),
         FALSE)

insertPF('beta', 'dbeta', FALSE, 'NONNEGATIVE', 
         data.frame(
           name=c('shape', 'scale'),
           min=c(0, 0),
           max=c(inf, inf),
           discrete=c(FALSE, FALSE),
           initial=c(1, 1)),
         FALSE)

insertPF('gamma', 'dgamma', FALSE, 'NONNEGATIVE',
         data.frame(
           name=c('shape', 'scale'),
           min=c(0, 0),
           max=c(inf, inf),
           discrete=c(FALSE, FALSE),
           initial=c(0, 1)),
         FALSE)

insertPF('exponential', 'dexp', FALSE, 'NONNEGATIVE', 
         data.frame(
           name=c('rate'),
           min=c(0),
           max=c(inf),
           discrete=c(FALSE),
           initial=c(1)),
         FALSE)

insertPF('f', 'df', FALSE, 'NONNEGATIVE', 
         data.frame(
           name=c('df1', 'df2'),
           min=c(0, 0),
           max=c(inf, inf),
           discrete=c(TRUE, TRUE),
           initial=c(50, 50)),
         FALSE)

## NEEDS AMENDING a < b.
#insertPF('uniform', 'dunif', FALSE, 'REAL', 
#         data.frame(
#           name=c('a', 'b'),
#           min=c(-inf, -inf),
#           max=c(inf, inf),
#           discrete=c(FALSE, FALSE),
#           initial=c(0, 0)),
#         FALSE)

insertPF('weibull', 'dweibull', FALSE, 'NONNEGATIVE', 
         data.frame(
           name=c('shape', 'scale'),
           min=c(0, 0),
           max=c(inf, inf),
           discrete=c(FALSE, FALSE),
           initial=c(1, 1)),
         FALSE)

insertPF('chi squared', 'dchisq', TRUE, 'NONNEGATIVE',
         data.frame(
           name=c('df'),
           min=c(0),
           max=c(inf),
           discrete=c(TRUE),
           initial=c(100)),
         FALSE)

insertPF('t', 'dt', TRUE, 'REAL',
         data.frame(
           name=c('df'),
           min=c(0),
           max=c(inf),
           discrete=c(TRUE),
           initial=c(100)),
         FALSE)

# Discrete
insertPF('binomial', 'dbinom', TRUE, 'NONNEGATIVE',
         data.frame(
           name=c('size', 'prob'),
           min=c(0, 0),
           max=c(inf, 1),
           discrete=c(TRUE, FALSE),
           initial=c(50, 0.5)),
         FALSE)

insertPF('negative binomial', 'dnbinom', TRUE, 'NONNEGATIVE',
         data.frame(
           name=c('size', 'prob'),
           min=c(0, 0),
           max=c(inf, 1),
           discrete=c(TRUE, FALSE),
           initial=c(100, 0.5)),
         FALSE)

insertPF('poisson', 'dpois', TRUE, 'NONNEGATIVE',
         data.frame(
           name=c('lambda'),
           min=c(0),
           max=c(inf),
           discrete=c(FALSE),
           initial=c(100)),
         FALSE)

insertPF('geometric', 'dgeom', TRUE, 'NONNEGATIVE',
         data.frame(
           name=c('prob'),
           min=c(0),
           max=c(1),
           discrete=c(FALSE),
           initial=c(0.5)),
         FALSE)

insertPF('hypergeometric', 'dhyper', TRUE, 'NONNEGATIVE',
         data.frame(
           name=c('m', 'n', 'k'),
           min=c(0, 0, 0),
           max=c(inf, inf, inf),
           discrete=c(TRUE, TRUE, TRUE),
           initial=c(10, 10, 10)),
         FALSE)

# Simulation.
x <- rf(10000, 5, 8)
hist(x, breaks=3.3*log(length(x)), probability=T)
lines(density(x), col='red')

findDistribution(x)