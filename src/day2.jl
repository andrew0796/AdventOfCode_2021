using DelimitedFiles

function ReadData(fname::AbstractString)
    return readdlm(fname)
end

function Part1(instructions::AbstractArray)
    x, y = 0, 0
    for i = 1:length(instructions[:,1])
        if instructions[i,1] == "forward"
            x += instructions[i,2]
        elseif instructions[i,1] == "up"
            y -= instructions[i,2]
        elseif instructions[i,1] == "down"
            y += instructions[i,2]
        end
    end

    return x*y
end


function Part2(instructions::AbstractArray)
    x, y, aim = 0, 0, 0
    for i = 1:length(instructions[:,1])
        if instructions[i,1] == "forward"
            x += instructions[i,2]
            y += instructions[i,2]*aim
        elseif instructions[i,1] == "up"
            aim -= instructions[i,2]
        elseif instructions[i,1] == "down"
            aim += instructions[i,2]
        end
    end

    return x*y
end

instructions = ReadData("../data/day2.txt")
println(Part1(instructions))
println(Part2(instructions))
