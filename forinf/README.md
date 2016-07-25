# forinf

_forinf_ is a set of tricks to work around formulas.

### Inference

As an _forinf_ subpart, *inference* infers a formula --or at least looks after
providing a good substitute-- out a input-response set.

So, in other words, it predicts _f_

```
f(X, Y) = Z
```

provided X, Y, and Z are float-vectors.

### Generator

_Generator_ outputs formulas out of a grammar capped at a given tree height.

Formulas are treated further in a separate environment in order to normalize
them, and in most of the cases canonize them.

Practical results are that equivalent, non-identical formulas (ie. normalized
but non-canonized) seldom appear.

### Installation

Make sure R, Maxima, and Python are installed.

### To-do

Generate a pool of grammars to solve more domain-specific problems

* Discover expression
* Discover 1-arg formula (various grammars)
* Discover 2-args formula (various grammars)
* Discover 3-args formula (various grammars)
* Discover 4- to 20-args formula (simpler grammars)

Make _forinf_ work for various domains.

Replace c() appending with
http://www.win-vector.com/blog/2015/07/efficient-accumulation-in-r/
