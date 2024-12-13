function enum(data::Variables, OA::optiArrays)

    #N = data.N

    # Assign priority queue
    pq = PriorityQueue{node{Int64}, Float64}(Base.Order.Forward)

    BestNode = node{Int64}()
    len::Float64 = 0.0
    enqueue!(pq,BestNode,len)

    upperbound::Float64 = typemax(Float64)

    while !isempty(pq) 

        currentNode = dequeue!(pq)
        Build_Subtree(currentNode, data)
        K = currentNode.level + 2  #Steiner point 
        children = 2*(currentNode.level) + 3

        for edge in 1:children
            SplitEdge(edge, currentNode.level, data)
            
            # Pre-Optimisation
            setInitialState(K, data, OA)
            len = optimise(0.1, K, data, OA)
            
            if (len < upperbound)
                if (K == N-2)
                    len = optimise(0.0001, K, data, OA)
                    if (len < upperbound)
                        upperbound = len 
                        BestNode = node{Int64}(edge, currentNode)
                        println("New Record Length = ",len)
                    end

                else 
                    child = node{Int64}(edge, currentNode)
                    enqueue!(pq, child, len)

                end
            end
        end
    end

    #1 allocation expected
    return BestNode
end