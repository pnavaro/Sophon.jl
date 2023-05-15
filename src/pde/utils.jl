function isongpu(nt::NamedTuple)
    return any(x -> x isa AbstractGPUArray, Lux.fcollect(nt))
end

float64 = Base.Fix1(convert, AbstractArray{Float64})

function get_l2_loss_function(loss_function, dataset)
    loss(θ) = mean(abs2, loss_function(dataset, θ))
    return loss
end

@inline null_additional_loss(phi, θ) = 0

"""
This function is only used for the first order derivative.
"""
forwarddiff(phi, t, εs, order, θ) = ForwardDiff.gradient(sum ∘ Base.Fix2(phi, θ), t)

function finitediff(phi, x, θ, εs, epsilon, order::Val{N}, ::Val{false}) where {N}
    ε = εs[N]
    _epsilon = ChainRulesCore.@ignore_derivatives epsilon[N]
    ε = ChainRulesCore.@ignore_derivatives adapt(parameterless_type(x), ε)
    return finitediff(phi, x, θ, ε, order, _epsilon)
end

function finitediff(phi, x, θ, εs, epsilon, order::Val{N}, mixed::Val{true}) where {N}
    ε = εs[N]
    _epsilon = ChainRulesCore.@ignore_derivatives epsilon[N]
    ε = ChainRulesCore.@ignore_derivatives adapt(parameterless_type(x), ε)

    return (finitediff(phi, x .+ ε, θ, @view(εs[1:(end - 1)]), @view(epsilon[1:(end - 1)]), Val(N-1), mixed) .-
            finitediff(phi, x .- ε, θ, @view(εs[1:(end - 1)]), @view(epsilon[1:(end - 1)]), Val(N-1), mixed)) .* _epsilon ./ 2
end

@inline function finitediff(phi, x, θ, ε::AbstractVector{T}, ::Val{1}, h::T) where {T<:AbstractFloat}
    return (phi(x .+ ε, θ) .- phi(x .- ε, θ)) .* h ./ 2
end

@inline function finitediff(phi, x, θ, ε::AbstractVector{T}, ::Val{2}, h::T) where {T<:AbstractFloat}
    return (phi(x .+ ε, θ) .+ phi(x .- ε, θ) .- 2 .* phi(x, θ)) .* h^2
end

@inline function finitediff(phi, x, θ, ε::AbstractVector{T}, ::Val{3}, h::T) where {T<:AbstractFloat}
    return (phi(x .+ 2 .* ε, θ) .- 2 .* phi(x .+ ε, θ) .+ 2 .* phi(x .- ε, θ) -
            phi(x .- 2 .* ε, θ)) .* h^3 ./ 2
end

@inline function finitediff(phi, x, θ, ε::AbstractVector{T}, ::Val{4}, h::T) where {T<:AbstractFloat}
    return (phi(x .+ 2 .* ε, θ) .- 4 .* phi(x .+ ε, θ) .+ 6 .* phi(x, θ) .-
            4 .* phi(x .- ε, θ) .+ phi(x .- 2 .* ε, θ)) .* h^4
end

function finitediff(phi, x, θ, dim::Int, order::Int)
    ε = ChainRulesCore.@ignore_derivatives get_ε(size(x, 1), dim, eltype(θ), order)
    _type = parameterless_type(ComponentArrays.getdata(θ))
    _epsilon = inv(first(ε[ε .!= zero(ε)]))

    ε = adapt(_type, ε)

    if order == 4
        return (phi(x .+ 2 .* ε, θ) .- 4 .* phi(x .+ ε, θ) .+ 6 .* phi(x, θ) .-
                4 .* phi(x .- ε, θ) .+ phi(x .- 2 .* ε, θ)) .* _epsilon^4
    elseif order == 3
        return (phi(x .+ 2 .* ε, θ) .- 2 .* phi(x .+ ε, θ, phi) .+ 2 .* phi(x .- ε, θ) -
                phi(x .- 2 .* ε, θ)) .* _epsilon^3 ./ 2
    elseif order == 2
        return (phi(x .+ ε, θ) .+ phi(x .- ε, θ) .- 2 .* phi(x, θ)) .* _epsilon^2
    elseif order == 1
        return (phi(x .+ ε, θ) .- phi(x .- ε, θ)) .* _epsilon ./ 2
    else
        error("The order $order is not supported!")
    end
end

function Base.getproperty(d::Symbolics.VarDomainPairing, var::Symbol)
    if var == :variables
        return getfield(d, :variables)
    elseif var == :domain
        return getfield(d, :domain)
    else
        idx = findfirst(v -> v.name === var, d.variables)
        domain = getfield(d, :domain)
        return Interval(infimum(domain)[idx], supremum(domain)[idx])
    end
end
