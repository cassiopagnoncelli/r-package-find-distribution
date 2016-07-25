Under-development collection of R libraries useful in data modeling context.

## Infer distribution

As title says, infer distribution intends to find the best-fit distribution for a given data set.

* **Input**: A numeric data set (univariate or multivariate)

* **Output**: Its best fit distribution among probability distribution functions database.

```r

# Sample from F(5,8) distribution.
x <- rf(10000, 5, 8)

# Searches for pdf candidates.
inferDistribution(x)
```

Output is a nice table listing best PDF candidates.

pf | error
--- | -----
df | 0.1717962
dgamma | 0.2105859
dlnorm | 0.2226137
dweibull | 0.2997514
dnorm | 0.5110258
dexp | 0.9432531
dbeta | 2.3016270

## Forinf

_Forinf_ stands for Formula Inference.

Given a sample of any numeric function, ie. domain and codomain,

<center>[ Y | x<sub>1</sub> x<sub>2</sub> ... x<sub>n</sub> ]</center>

it tries to infer a good-fitting formula so as

<center>f(x<sub>1</sub>, x<sub>2</sub>, ..., x<sub>n</sub>) = Y</center>

or, at least, a good approximation.
