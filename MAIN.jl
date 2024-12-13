

# Set these values before each run and restart REPL 
global const N = 6 # Number of terminals
global const D = 3 # Dimension

include("./Generators/Simplex_generator.jl")
include("./Generators/N_D_generator.jl")

include("./Smiths.jl")
include("./Output.jl")
include("./plots/plots.jl")


function run(T::Vector{Vector{Float64}}, plot::Bool)

    #N = length(T)
    #D = length(T[1])

    count = 0
    for i in eachindex(T)
        if T[1] == T[i]
            count +=1
        end
    end

    if count == N
        println("Error: All points are the same")
        return nothing
    end

    println("Terminals: ",length(T))
    println("Dimension: ",length(T[1]))

    len, data = Smiths(T)
    output(data,len)

    if (D==2) && (plot==true)
        plot2D(N, len, data)

    elseif (D==3) && (plot==true)
        plot3D(N, len, data)
    end

    return nothing
end


simp = simplex(N)
nd = N_D(N,D)

icso = [[1, 0, 1.6180339887],
[0, 1.6180339887, 1], 
[1.6180339887, 1, 0],
[-1, 0, 1.6180339887],
[0, 1.6180339887, -1], 
[1.6180339887, -1, 0],
[1, 0, -1.6180339887],
[0, -1.6180339887, 1],
[-1.6180339887, 1, 0],
[-1, 0, -1.6180339887],
[0, -1.6180339887, -1],
[-1.6180339887, -1, 0]]


N42 = [[0.0, 0.0], 
    [0.0,1.0],
    [1.0,0.0],
    [1.0,1.0]]

cube = [[0.0, 0.0, 0.0],
    [1.0, 0.0, 0.0],
    [1.0, 1.0, 0.0],
    [0.0, 1.0, 0.0],
    [1.0, 0.0, 1.0],
    [0.0, 0.0, 1.0],
    [1.0, 1.0, 1.0],
    [0.0, 1.0, 1.0]]

tetra = [[0.0, 0.0, 0.0], 
    [1.0, 1.0, 0.0], 
    [0.0, 1.0, 1.0], 
    [1.0, 0.0, 1.0]]

octa = [[1.0, 0.0, 0.0],
        [-1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, -1.0, 0.0],
        [0.0, 0.0, 1.0],
        [0.0, 0.0, -1.0]]

N32 = [[0.0, 0.0], 
        [0.0,1.0],
        [1.0,0.0]]

run(octa,true)

