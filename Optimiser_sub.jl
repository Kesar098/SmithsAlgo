function Optimiser_sub(tol::Float64, K::Integer, data::Variables, OA::optiArrays)

    #N = data.N
    #D = data.D
    V = data.Terminals 
    adj = data.adj 
    EL = data.EL

    B = OA.B
    C = OA.C
    eqnstack = OA.eqnstack
    leafQ = OA.leafQ
    val = OA.val
    

    j = m = i2 = 0
    lqp::Int = 1
    eqp::Int = 1
    
    fill!(B,0.0)
    fill!(C,0.0)
    fill!(val,0)

    #display(adj)
    # First: compute B array, C array, and valences. Set up leafQ.
    @inbounds @simd for i in 1:K

        n1 = adj[i,1]
        n2 = adj[i,2]
        n3 = adj[i,3]

        
        q1 = 1.0 ./ (EL[i,1] .+ tol)
        q2 = 1.0 ./ (EL[i,2] .+ tol)
        q3 = 1.0 ./ (EL[i,3] .+ tol)

        t = q1 .+ q2 .+ q3
        q1 = q1./t
        q2 = q2./t
        q3 = q3./t
        

        if (n1>N)
            val[i]+=1
            B[i,1] = q1
        else 
            C[i,:] += V[n1] .* q1
        end

        if (n2>N)
            val[i]+=1
            B[i,2] = q2
        else 
            C[i,:] +=  V[n2] .* q2
        end

        if (n3>N)
            val[i]+=1
            B[i,3] = q3
        else 
            C[i,:] += V[n3] .* q3
        end


        # Put leaves in leafQ
        if (val[i] <= 1)
            leafQ[lqp] = i
            lqp +=1
        end
    end


    #display(adj)

    #Have set up equations - now-to solve them.
    #Second: eliminate leaves
    while lqp > 2
        #display(B)
        #display(leafQ)
        #display(val)
        lqp -= 1
        i = leafQ[lqp]
        val[i]-=1
        i2 = i + N 
        #println("lqp = $lqp")

        # Now to eliminate leaf i
        eqnstack[eqp] = i #Push i onto stack
        eqp+=1
    
        for z in 1:3
            j = z
            if B[i,j] != 0.0
                break
            end
        end

        # neighbor is j
        q1 = B[i,j]

        #=println("i = $i")
        println("j = $j")
        println("adj = ", adj[i,j])=#

        j = adj[i,j] .- N
        #println("stp = $j")
        val[j]-=1
        
        #new leaf?
        if (val[j] == 1)
            leafQ[lqp] = j 
            lqp+=1
        end

        @inbounds for z in 1:3
            m = z
            if adj[j,m] == i2
                break
            end
        end

        q2 = B[j,m]
        B[j,m] = 0.0 
        t = 1.0 .- q2 .* q1
        t = 1.0./t
        
        for m in 1:3
            B[j,m] *= t
        end
        
        for m in 1:D
            C[j,m] += q2 .* C[i,m]
            C[j,m] *= t
        end
    end

    ## One allocation in third solve
    # Third: Solve 1-vertex tree!
    i = leafQ[1]; 
    i2 = i .+ N;

    V[i2] .= C[i,:]
    
    #=for z in 1:D 
        V[i2][z] = C[i,z]
    end=#


    #Fourth: backsolve
    while eqp > 1
        eqp-=1
        i = eqnstack[eqp]
        i2 = i .+ N
        
        for z in 1:3
            j = z
            if B[i,j] != 0.0
                break
            end
        end

        q1 = B[i,j]
        j = adj[i,j]

        V[i2] .= C[i,:] .+ q1 .* V[j]

        #=for z in 1:D 
            V[i2][z] = C[i,z] + q1 * V[j][z]
        end=#
    end
    
    return nothing
end

