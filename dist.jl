

@inline function dist(p::T,q::T) where {T<:AbstractVector}
    x::Float64 = 0.0
    @inbounds @simd for i in eachindex(p) 
        x += (p[i] - q[i])^2
    end
    x = sqrt(x)
    return x
end