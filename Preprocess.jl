function dist_Centroid(V::Vector{Vector{Float64}})

    #N::Int = length(V)
    #D::Int = length(V[1])

    cen = Vector{Float64}(undef,D)

    for i in 1:N
        cen += V[i]
    end
    cen = cen./N

    sort!(V, rev = true, by = p -> dist(p, cen))

    return nothing
end

function firstThree(V::Vector{Vector{Float64}})
    order = Int[0 for _ in 1:N]
    maxDist::Float64 = 0

    # Find three sites furthest apart and put them in order[1:3]
    for i in 1:N 
        for j in i+1:N
            dij = dist(V[i],V[j])
            for k in j+1:N
               dik = dist(V[i],V[k])
               djk = dist(V[j],V[k]) 

               m = dij+dik+djk
               if (dij+dik+djk>maxDist)
                    maxDist = m
                    order[1] = i 
                    order[2] = j
                    order[3] = k 
               end
            end
        end
    end
    return order
end



function remaining(V::Vector{Vector{Float64}}, order::Vector)

    remaining = Int[x for x in 1:N] #MVector{N,Int}(x for x in 1:N)
    added = Int[]


    for i in 1:3
        push!(added,order[i])
        deleteat!(remaining,findfirst(x -> x=== order[i], remaining))
    end
 
    for i in 4:N
        maxDist::Float64 = 0
        maxR::Int = 0

        for r in remaining
            for a in added
                d::Float64 = dist(V[r],V[a])

                if d > maxDist
                    maxDist = d
                    maxR = r
                end
            end
        end

        push!(added,maxR)
        deleteat!(remaining,findfirst(x -> x===maxR, remaining))

        order[i] = maxR
        
    end
    return order
end


function FurtherestSite(V::Vector{Vector{Float64}})

    #N::Int = length(V)
    order = firstThree(V)

    order = remaining(V,order)
    
    for i in eachindex(order)
        temp = V[i]
        V[i] = V[order[i]]
        V[order[i]] = temp
    end

    return V
end