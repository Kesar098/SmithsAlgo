
function build_KVector(CN::node, data::Variables)
    kVector = MVector(data.kVector)
    L = CN.level
    for i in 1:L
        kVector[CN.level] = CN.edgeSplit
        CN = CN.parent
    end

    data.kVector = SVector(kVector)
    return nothing
end


function Build_Subtree(CN::node, data::Variables)
        
    #N = data.N

    edges = data.edges
    kVector = data.kVector
    
    L = CN.level
    stp = N + 1

    @inbounds for _ in 1:L
        kVector[CN.level] = CN.edgeSplit
        CN = CN.parent
    end

    #=
    build_KVector(CN, data)
    kVector = data.kVector

    while !isnothing(CN.parent)
        kVector[CN.level] = CN.edgeSplit
        CN = CN.parent
    end
    =#

    # Build edge matrix
    edges[1,1], edges[1,2] = 1, stp
    edges[2,1], edges[2,2] = 2, stp
    edges[3,1], edges[3,2] = 3, stp

    e = 3

    @inbounds for i in 1:L

        es = kVector[i]
        stp +=1
        e2 = edges[es, 2]

        edges[es, 2] = stp
        
        e+=1
        edges[e,1] = e2
        edges[e,2] = stp

        e+=1
        edges[e,1] = i + 3
        edges[e,2] = stp
    end

    return nothing
end


function SplitEdge(e::Integer, L::Integer, data::Variables)

    #N = data.N
    adj = data.adj
    edges = data.edges

    g = L + L + 3
    newTer = L + 4
    newStp = L + 2

    fill!(adj,0)
    
    #count = MVector{N-2,Int64}(0 for _ in 1:N-2)

    # Build Adjancey matrix 
    @inbounds for i in 1:g

        ea = edges[i,1]
        e1 = ea - N
        
        eb = (i === e ? newStp + N : edges[i,2])
        e2 = (i === e ? newStp : edges[i,2] - N)

        if (e1>=1)
            a = findfirst(x -> x === 0, adj[e1, :])
            #count[e1]+=1
            adj[e1, a] = eb
        end

        if (e2>=1)
            a = findfirst(x -> x === 0, adj[e2, :])
            #count[e2]+=1
            adj[e2, a] = ea
        end
    end

    # add two new edges to adjacency
    e1 = edges[e,2] .- N
    adj[e1, 3] = newStp .+ N
    adj[newStp, 2] = edges[e,2]     
    adj[newStp, 3] = newTer

    return nothing
end


#=
function BuildTree(e::Int, CN::node, data::Variables)
    es::Int = e1::Int = e2::Int = 0
    stp::Int = data.N + 1
    L::Int = CN.level + 1
    g::Int = 2*(L)+3

    adj = data.adj
    edges = data.edges
    kVector = data.kVector

    kVector[L] = e 
    #terTemp[L] = L+3

    while !isnothing(CN.parent)
        kVector[CN.level] = CN.edgeSplit
        #terTemp[CN.level] = CN.terminalInserted
        CN = CN.parent

    end

    # Build edge matrix
    edges[1,1], edges[1,2] = 1, stp
    edges[2,1], edges[2,2] = 2, stp
    edges[3,1], edges[3,2] = 3, stp

    e = 3
    
    for i in 1:L

        es = kVector[i]
        stp = data.N + i + 1
        e2 = edges[es, 2]

        edges[es, 2] = stp
        
        e+=1
        edges[e,1] = e2
        edges[e,2] = stp

        e+=1
        edges[e,1] = i+3
        edges[e,2] = stp

    end

    #Build adjacency matrix
    adj[1,1], adj[1,2], adj[1,3] = 1, 2, 3

   #= count = Vector{Int}(undef,L+1)
    fill!(count,0)

    for i in 1:g
        e1 = edges[i,1] .- data.N
        e2 = edges[i,2] .- data.N

        if (e1>=1)
            count[e1]+=1
            adj[e1, count[e1]] = edges[i,2]
        end

        if (e2>=1)
            count[e2]+=1
            adj[e2, count[e2]] = edges[i,1]
        end        
    end=#

    
    fill!(adj,0)

    a::Int = 1
    for i in 1:g
        e1 = edges[i,1] .- data.N
        e2 = edges[i,2] .- data.N

        

        if (e1>=1)
            @views a = findfirst(x -> x == 0, adj[e1, :])
            
            #=a = 1
            while adj[e1,a] != 0
                a+=1
            end=#

            adj[e1, a] = edges[i,2]
        end

        if (e2>=1)
            @views a = findfirst(x -> x == 0, adj[e2, :])

            #=a = 1
            while adj[e2,a] != 0
                a+=1
            end=#

            adj[e2, a] = edges[i,1]
        end        
    end
    return nothing
end
=#
