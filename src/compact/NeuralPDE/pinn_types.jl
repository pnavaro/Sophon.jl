struct PINN{PHI, P, T, DER, ADA, K} <: NeuralPDE.AbstractPINN
    phi::PHI
    init_params::P
    strategy::T
    derivative::DER
    additional_loss::Any
    adaptive_loss::ADA
    kwargs::K
end

function PINN(chain, strategy; init_params=nothing, derivative=NeuralPDE.numeric_derivative,
              additional_loss=nothing, adaptive_loss=NonAdaptiveLoss{Float32}(), kwargs...)
    phi = chain isa NamedTuple ? ChainState.(chain) : ChainState(chain)

    return PINN{typeof(phi), typeof(init_params), typeof(strategy), typeof(derivative),
                typeof(adaptive_loss), typeof(kwargs)}(phi, init_params, strategy,
                                                       derivative, additional_loss,
                                                       adaptive_loss, kwargs)
end

"""
    ChainState(model, rng::AbstractRNG=Random.default_rng())

Wraps a model in a stateful container.

## Arguments

    - `model`: `AbstractExplicitLayer`, or a named tuple of them, which will be treated as a `Chain`.
"""
mutable struct ChainState{L, S}
    model::L
    state::S
end

function ChainState(model, rng::AbstractRNG=Random.default_rng())
    states = initialstates(rng, model)
    return ChainState{typeof(model), typeof(states)}(model, states)
end

function ChainState(model, state::NamedTuple)
    return ChainState{typeof(model), typeof(state)}(model, state)
end

function ChainState(; rng::AbstractRNG=Random.default_rng(), kwargs...)
    return ChainState((; kwargs...), rng)
end

@inline ChainState(a::ChainState) = a

@inline function initialparameters(rng::AbstractRNG, s::ChainState)
    return initialparameters(rng, s.model)
end

function (c::ChainState{<:NamedTuple})(x, ps)
    y, st = Lux.applychain(c.model, x, ps, c.state)
    ChainRulesCore.@ignore_derivatives c.state = st
    return y
end

function (c::ChainState{<:AbstractExplicitLayer})(x, ps)
    y, st = c.model(x, ps, c.state)
    ChainRulesCore.@ignore_derivatives c.state = st
    return y
end

const NTofChainState{names} = NamedTuple{names, <:Tuple{Vararg{ChainState}}}

# construct a new ChainState
function Lux.cpu(c::ChainState)
    return ChainState(c.model, cpu(c.state))
end

function Lux.gpu(c::ChainState)
    return ChainState(c.model, gpu(c.state))
end
