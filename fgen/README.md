# fgen

_fgen_ is a set of tricks to work around formulas.

### Inference

As an fgen subpart, *inference* infers a formula --or at least looks after
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
