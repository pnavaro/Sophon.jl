# Sophon

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://yichengdwu.github.io/Sophon.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://yichengdwu.github.io/Sophon.jl/dev/)
[![Build Status](https://github.com/YichengDWu/Sophon.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/YichengDWu/Sophon.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/YichengDWu/Sophon.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/YichengDWu/Sophon.jl)
[![DOI](https://zenodo.org/badge/521846679.svg)](https://zenodo.org/badge/latestdoi/521846679)

`Sophon.jl` provides specialized neural networks and neural operators for Physics-informed machine learning. 

Use the [documentation](https://yichengdwu.github.io/Sophon.jl/dev/) to explore the features.

Please star this repository if you find it useful.

## Installation

```julia
julia>] add Sophon
```
## Gallery
| ![](assets/functionfitting.svg)     | ![](assets/poisson.png)                 | ![](assets/examples/DecayingTurbulence2D.png)                | ![](assets/examples/TaylorGreenVortex2D.png)                |
|:---------------------------------------:|:-------------------------------------------------------------:|:------------------------------------------------------------:|:-----------------------------------------------------------:|
| [Function Fitting)](https://yichengdwu.github.io/Sophon.jl/dev/tutorials/discontinuous/) | [Multi-scale Poisson Equation)](https://yichengdwu.github.io/Sophon.jl/dev/tutorials/poisson/) | [Decaying Turbulence (2D)](examples/DecayingTurbulence2D.jl) | [Taylor-Green Vortex (2D)](examples/TaylorGreenVortex2D.jl) |
| ![](assets/allen.png)     | ![](assets/Schrödinger.png)                 | ![](assets/Lshape.png)                |              |
| [Allen-Cahn Equation](https://yichengdwu.github.io/Sophon.jl/dev/tutorials/allen_cahn/) | [Schrödinger equation](https://yichengdwu.github.io/Sophon.jl/dev/tutorials/Schr%C3%B6dingerEquation/) | [L-shaped Domain](https://yichengdwu.github.io/Sophon.jl/dev/tutorials/L_shape/) |  |
## Related Libraries

- [NeuralPDE](https://github.com/SciML/NeuralPDE.jl)
- [PaddleScience](https://github.com/PaddlePaddle/PaddleScience)
- [MindScience](https://gitee.com/mindspore/mindscience)
- [Modulus](https://docs.nvidia.com/deeplearning/modulus/index.html#)
- [DeepXDE](https://deepxde.readthedocs.io/en/latest/index.html#)
