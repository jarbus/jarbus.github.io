---
title: "Numerical Stability in Flash Attention"
date: 2023-07-27T14:21:08-04:00
tags: ["programming"]
---

[Flash attention](https://hazyresearch.stanford.edu/blog/2023-01-12-flashattention-long-sequences), a recent implementation of attention which makes less calls 
to high-bandwidth memory, uses a version of the softmax function which is numerically stable. In this post, I'll briefly showcase how this is done and an example of an unstable softmax.

The softmax function is used in machine learning to convert a vector of
real numbers to a vector of probabilities which sum to 1, and is defined as:

    softmax(x) = [exp(x[i]) / sum([exp(xj) for xj in x]) for xi in x]


where x is a vector of real numbers.

The python implementation below is numerically unstable because it involves
exponentiation of large numbers, which can lead to overflow. Crucially,
underflow is not an issue, because exp(x) approaches zero when x is a large
negative number.
```python
import numpy as np
def unstable_softmax(x):
    fx_unstable = np.exp(x)
    return fx_unstable / np.sum(fx_unstable)
```

The following implementation is stable however, because there is no
exponentiation of large numbers: 
```python
def stable_softmax(x):
    fx_stable = x - np.max(x)
    return np.exp(fx_stable) / np.sum(np.exp(fx_stable))
```
Instead, the max of the vector is subtracted from each element. This does not 
change the result of the softmax after the division as this subtraction is also
performed in the denominator, thus cancelling out.

Let's compare the two implementations:
```python
>>> a = np.array([6.0, -3, 15], dtype=np.float32)
>>> stable_softmax(a)
[1.2339458e-04 1.5228101e-08 9.9987662e-01]
>>> unstable_softmax(a)
[1.2339458e-04 1.5228101e-08 9.9987656e-01]
```

As you can see, the results are mostly equal, save for a few digits.
Now let's look at what happens with 16 bits of precision:

```python
>>> a = np.array([6.0, -3, 15], dtype=np.float16)
>>> stable_softmax(a)
[ 0.  0. nan]
>>> unstable_softmax(a)
[ 1.234e-04 0.000e+00 1.000e+00]
```

When working with 16 bits of precision, we observe that exp(15) produces a numerical overflow
which turns the third element into a NaN. This is because exp(15) produces a value that can
not be represented by a float16.

To recap, we showed that softmax is numerically unstable, especially when working with small precision bits. Because softmax uses exponentials in the numerator and denominator, we can subtract all exponents by the maximum exponent, constraining all the values between 0 and 1 and preventing numerical overflow.
