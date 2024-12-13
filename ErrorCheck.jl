function Error(K::Int64, data::Variables)::Float64

    #N = data.N
    V = data.Terminals 
    adj = data.adj 
    EL = data.EL

    error::Float64 = 0.0 

    @inbounds @simd for i in 1:K
        s = N .+ i
        n1 = adj[i,1]
        n2 = adj[i,2]
        n3 = adj[i,3]

        a = V[n1] .- V[s]
        b = V[n2] .- V[s]
        c = V[n3] .- V[s]

        d12 = dot(a,b)
        d13 = dot(a,c)
        d23 = dot(b,c)

        #=println("dot-values")
        println(d12)
        println(d13)
        println(d13)=#

        d12 = (d12 .+ d12) .+ (EL[i,1] .* EL[i,2])
        d13 = (d13 .+ d13) .+ (EL[i,1] .* EL[i,3])
        d23 = (d23 .+ d23) .+ (EL[i,2] .* EL[i,3])

        #=println("E-values")
        println(T.EL[i,1])
        println(T.EL[i,2])
        println(T.EL[i,3])=#

        d12 = (d12 > 0.0 ? d12 : 0.0)
        d13 = (d13 > 0.0 ? d13 : 0.0)
        d23 = (d23 > 0.0 ? d23 : 0.0)

        #=println("d-values")
        println(d12)
        println(d13)
        println(d23)=#

        error += d12 + d13 + d23
    end

    error = sqrt(error)
    return error
end
