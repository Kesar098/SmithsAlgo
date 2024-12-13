function setInitialState(K::Int, data::Variables, OA::optiArrays)
    #N = data.N
    #D = data.D
    V = data.Terminals 
    adj = data.adj 
  
    V[N+1] .= (V[1] .+ V[2] .+ V[3]) ./3.0
    
    @inbounds @simd for i in 2:K
        n1 = adj[i,1]
        n2 = adj[i,2]
        n3 = adj[i,3]
        
        V[N+i] .= (V[n1] .+ V[n2] .+ V[n3]) ./3.0
        
    end
    return nothing
end


#=function setInitialState(K::Int, data::Variables, OA::optiArrays)
    #N = data.N
    #D = data.D
    V = data.Terminals 
    adj = data.adj 
    val = OA.val

    fill!(val,0)
    # Setup val (degree)
    for i in 1:K
        for j in 1:3
            if adj[i,j] <= N
                val[i]+=1
            end
        end
    end
end=#

