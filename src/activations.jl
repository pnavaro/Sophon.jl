@doc raw"""
    gaussian(x, a=0.2)
The Gaussian activation function.

```math
e^{\frac{-0.5 x^{2}}{a^{2}}}
```
## References

[1] Ramasinghe, Sameera, and Simon Lucey. "Beyond periodicity: Towards a unifying framework for activations in coordinate-mlps." arXiv preprint arXiv:2111.15135 (2021).

"""
gaussian(x, a=0.2) = exp(-(x / NNlib.oftf(x, a))^2 / 2)
quadratic(x, a=5) = 1 / (1 + (NNlib.oftf(x, a) * x)^2)
multiquadratic(x, a=10) = 1 / sqrt((1 + (NNlib.oftf(x, a) * x)^2))
laplacian(x, a=0.01) = exp(-abs(x) / NNlib.oftf(x, a))
expsin(x, a=1) = exp(-sin(a * x))
function wu(x,a=1) =
    x = NNlib.oftf(x, a)*x
    return x*(5*x^2-1)/(1+x^2)^4
end
