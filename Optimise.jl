function optimise(tol::Float64, K::Integer, data::Variables, OA::optiArrays)
    #N = data.N
    len::Float64 = lengthTree(K, data)
    error::Float64 = Error(K, data)

    while (error > len * (tol))

        Optimiser_sub((0.0001)*(error/N), K, data, OA)
        len = lengthTree(K, data)
        error = Error(K, data)
    end

    return len
end






