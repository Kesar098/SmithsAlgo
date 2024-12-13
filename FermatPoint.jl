
const theta = (2*pi)/3
const alpha = pi/3

function angle2(a::T,b::T,c::T) where {T<:Union{MVector, SVector}}
    # Fast but inaccurate
    u  = (a.-b)
    v  = (a.-c)
    p = acos(dot(u,v)./(norm(u) .* norm(v)))
    return p
end


function angle(a::T,b::T,c::T) where {T<:Union{MVector, SVector}}
    # Accurate but slow
    p  = (a.-b) ./ dist(a,b)
    q  = (a.-c) ./ dist(a,c)
    ang::Float64 = 2 .* atan(norm(p.-q), norm(p.+q))
    return ang
end


function fermat(data::Variables)

    A = data.Terminals[1]
    B = data.Terminals[2]
    C = data.Terminals[3]

    A_t::Float64 = angle(A,B,C)
    if (A_t >= theta) || isnan(A_t)
        data.Terminals[4] = A
        return nothing
    end

    B_t::Float64 = angle(B,A,C)
    if (B_t >= theta) || isnan(B_t)
        data.Terminals[4] = B
        return nothing
    end

    C_t::Float64 = angle(C,A,B)
    if (C_t >= theta) || isnan(C_t)
        data.Terminals[4] = C
        return nothing
    end

    a::Float64 = A_t .+ alpha
    b::Float64 = B_t .+ alpha
    c::Float64 = C_t .+ alpha

    a = sin(A_t)./sin(a)
    b = sin(B_t)./sin(b)
    c = sin(C_t)./sin(c)
    
    data.Terminals[4] .= ((a .* A) .+ (b .* B) .+ (c .* C)) ./ (a .+ b .+ c)
    return nothing
end