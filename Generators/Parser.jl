
function StringtoArray(file_path::String)
    # read file and convert to String
    raw = open(io->read(io,String), file_path)

    # Split the file content into lines
    lines = split(raw, '\n')
    Terminals = Vector{Vector{Float64}}()
    in_coordinates_section = false
    
    for line in lines
        if occursin("SECTION Coordinates", line)
            in_coordinates_section = true
            continue
        end
        if occursin("END", line) && in_coordinates_section
            break
        end
        
        if in_coordinates_section && startswith(line, "D")
            # Remove D from the start
            line = lstrip(line, 'D')
            clean_line = lstrip(line)  # Remove any spaces after D

            ter = parse.(Float64, split(clean_line)[2:end])
            
            # Append the coordinates to the vector
            if length(ter) != 0
                push!(Terminals, ter)
            end
        end
    end
    
    return Terminals
end

coordinates = StringtoArray("/Users/K/Documents/Masters/MA498 Dissertation/code/MPC15-masterLin/MPC15-master/experiments/Solids/Instances/cube.stp")
