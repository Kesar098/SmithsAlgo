function Compute_distmx(data::Variables, OA::optiArrays)
    #N = 
    #D = 
    V = data.Terminals
    distmx = OA.distmx
    
    # Initialize the adjacency matrix with distances
    @inbounds @simd for i in 1:N
        @inbounds @simd for j in 1:N
            if i != j
                distmx[i, j] = norm(V[i] .- V[j])
            else
                distmx[i, j] = Inf
            end
        end
    end
end


function MST(K::Int, data::Variables, OA::optiArrays)

    H = K + 3
    V = data.Terminals
    adj = data.adj
    distmx = OA.distmx


    # Prim's algorithm
    selected = MVector{H,Bool}(false for _ in 1:H)
    selected[1] = true
    len::Float64 = 0.0

    for _ in 1:(H - 1)
        min_dist = Inf
        u::Int = v::Int = -1

        for i in 1:H
            if selected[i]
                for j in 1:H
                    if !selected[j] && distmx[i, j] < min_dist
                        min_dist = distmx[i, j]
                        u = i
                        v = j
                    end
                end
            end
        end

        len += min_dist
        selected[v] = true
    end
    return len
end
