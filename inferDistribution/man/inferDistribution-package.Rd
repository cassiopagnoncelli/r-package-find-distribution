\name{inferDistribution}
\alias{inferDistribution}
\alias{inferDistribution}
\docType{package}
\title{
\packageTitle{inferDistribution}
}
\description{
\packageDescription{inferDistribution}
}
\details{

The DESCRIPTION file:
\packageDESCRIPTION{inferDistribution}
\packageIndices{inferDistribution}
This package brings along one function, inferDistribution.

Equipped with that you are able to infer the most likely distribution of each axis in your dataset.
}
\author{
\packageAuthor{inferDistribution}

Maintainer: \packageMaintainer{inferDistribution}
}
\references{
FELLER, William. An introduction to probability theory and its applications. 1950. First edition.
}
~~ Optionally other standard keywords, one per line, from file KEYWORDS in the R ~~
~~ documentation directory ~~
\keyword{ package }
\seealso{
Other packages provide similar or complimentary functionalities. See
\code{\link[fitdistrplus:fitdistrplus]{fitdistrplus}}
and
\code{\link[mcstoc:mcstoc]{mcstoc}}.
}
\examples{
x <- rf(10000, 5, 8)
hist(x, breaks=3.3*log(length(x)), probability=T)
lines(density(x), col='red')

inferDistribution(x)
}
