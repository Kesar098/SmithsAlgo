function getAdj(CN::node, data::Variables)
    #N = data.N

    es::Int = e1::Int = e2::Int = 0
    stp::Int = N + 1
    L::Int = CN.level
    g::Int = 2*(L)+3

    adj = data.adj
    edges = data.edges
    kVector = data.kVector

    while !isnothing(CN.parent)
        kVector[CN.level] = CN.edgeSplit
        CN = CN.parent

    end

    # Build edge matrix
    edges[1,1], edges[1,2] = 1, stp
    edges[2,1], edges[2,2] = 2, stp
    edges[3,1], edges[3,2] = 3, stp

    e = 3
    for i in 1:L

        es = kVector[i]
        stp = N + i + 1
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
    fill!(adj,0)

    a::Int = 1
    for i in 1:g
        e1 = edges[i,1] .- N
        e2 = edges[i,2] .- N

        if (e1>=1)
            a = findfirst(x -> x == 0, adj[e1, :])
            adj[e1, a] = edges[i,2]
        end

        if (e2>=1)
            a = findfirst(x -> x == 0, adj[e2, :])
            adj[e2, a] = edges[i,1]
        end        
    end
    return nothing
end



function output(data::Variables, len::Float64)
    #N = data.N
    #D = data.D
    V = data.Terminals
    adj = data.adj

    # Print Terminals
    println("\nTerminals and Steiner Points: ")
    for i in 1:(N+N-2)
        println("$i: ", V[i])
    end

    #Print adj, kVector and length
    if (N==3)
        println("\nAdjancey Matrix:")
            println("4: ", [1, 2, 3])

        println("\nLength of tree = $len")

    else
        println("\nAdjancey Matrix:")
        for i in 1:N-2
            s = i + N
            println("$s: ", adj[i,:])
        end

        println("\nkVector = ",data.kVector)
        println("\nLength of tree = $len")
    end

    return nothing
end