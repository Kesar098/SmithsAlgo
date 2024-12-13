using LinearAlgebra
using StaticArrays
using Random
Random.seed!(1234)
using DataStructures
#using LoopVectorization

# Packages for tesing code performance
#using AllocCheck
using BenchmarkTools

include("./dist.jl")
#include("./Initialise.jl")
include("./Initialise_Const.jl")
include("./node.jl")

include("./MST.jl")

include("Preprocess.jl")

include("./BuildTree.jl")
include("./ErrorCheck.jl")
include("./LengthTree.jl")

include("./SetInitialState.jl")
include("./Optimise.jl")
include("./Optimiser_sub.jl")

include("./FermatPoint.jl")
include("./Enum_Scheme.jl")




function three(data::Variables)
    fermat(data)

    return nothing
end



function Smiths(T::Vector{Vector{Float64}})

    start = time()

    ### Preprocessing: Sort Terminals ###
    #dist_Centroid(V)
    Fs = FurtherestSite(T)

    ### Intialisation: Setup up structs ###
    data = intialisation_const(Fs)
    OA = optiArrays{Float64,Int}(N,D)

    Compute_distmx(data,OA)
    #@time MST(data,OA)
    
    
    finish = time()
    tt = finish-start
    println("Preprocessing Complete: $tt seconds.")

    ### Main Process ###
    println("Main Process Started!")
    start = time()
    # Special Case for 3 terminals
    if (N == 3)
        fermat(data)

        # build edge matrix
        data.edges[1,1] = 1
        data.edges[2,1] = 2
        data.edges[3,1] = 3
        data.edges[1,2] = data.edges[2,2] = data.edges[3,2] = 4

        A = data.Terminals[1]
        B = data.Terminals[2]
        C = data.Terminals[3]
        S = data.Terminals[4]

        len = dist(A,S) + dist(B,S) + dist(C,S)

        finish = time()
        tt = finish-start
        println("Time taken: $tt seconds.")
        return len, data
    end


    bestnode = enum(data, OA)
    finish = time()
    tt = finish-start
    println("Time taken: $tt seconds.")

    getAdj(bestnode, data)
    len::Float64 = optimise(0.0001, bestnode.level + 1, data, OA)
    output(data, len)

    return len, data
end
