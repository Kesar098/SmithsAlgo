struct Variables{T1<:Float64,T2<:Integer}
    Terminals::Vector{MVector{D, T1}} #Change to Vertices
    EL::MMatrix{N-2, 3, T1, 3*(N-2)}
    adj::MMatrix{N-2, 3, T2, 3*(N-2)}
    edges::MMatrix{N+N-3, 2, T2, 2*(N+N-3)}
    kVector::MVector{N-3, T2}
end


struct optiArrays{T1<:Float64,T2<:Integer}
    B::MMatrix{N-2, 3, T1, 3*(N-2)}
    C::MMatrix{N-2, D, T1, D*(N-2)}
    distmx::MMatrix{N, N, T1, N*N}
    eqnstack::MVector{N, T2}
    leafQ::MVector{N, T2}
    val::MVector{N-2, T2}

    # Constructor
    function optiArrays{T1,T2}(N::Int,D::Int) where {T1, T2}

        B = MMatrix{N-2, 3, T1, 3*(N-2)}(0.0 for _ in 1:(N-2), _ in 1:3)
        C = MMatrix{N-2, D, T1, D*(N-2)}(0.0 for _ in 1:(N-2), _ in 1:D)
        distmx = MMatrix{N, N, T1, N*N}(0.0 for _ in 1:N, _ in 1:N)
        eqnstack = MVector{N, T2}(0 for _ in 1:N)
        leafQ = MVector{N, T2}(0 for _ in 1:N)
        val = MVector{N-2, T2}(0 for _ in 1:(N-2))

        return new{T1,T2}(B, C, distmx, eqnstack, leafQ, val)
    end
end


function intialisation_const(V::Vector{Vector{Float64}})
    
    T = MVector{D,Float64}[]
    for i in 1:N
        push!(T,MVector{D,Float64}(V[i]))
    end

    for i in 1:N-2
        push!(T,MVector{D,Float64}(x for x in 1:D))
    end
    

    # data struct
    a = N-2
    b = N+N-3

    EL = MMatrix{a, 3, Float64}(0.0 for x in 1:a, _ in 1:3)
    adj = MMatrix{a, 3, Int}(0 for _ in 1:a, _ in 1:3)
    edges = MMatrix{b, 2, Int}(0 for _ in 1:b, _ in 1:2)
    kVector = MVector{a-1, Int}(0 for _ in 1:a-1)
    data = Variables(T, EL, adj, edges, kVector)


    #= optimiser arrays

    B = MMatrix{a, 3, Float64}(0.0 for _ in 1:a, _ in 1:3)
    C = MMatrix{a, D, Float64}(0.0 for _ in 1:a, _ in 1:D)
    eqnstack = MVector{N,Int64}(0 for x in 1:N)
    leafQ = MVector{N,Int64}(0 for x in 1:N)
    val = MVector{a,Int64}(0 for x in 1:a)

    OA = optiArrays(B, C, eqnstack, leafQ, val)=#

    return data
end


