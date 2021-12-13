using DelimitedFiles

function ReadData(fname::AbstractString)
    dataStr = readdlm(fname, String)

    data = zeros(Int, length(dataStr), length(dataStr[1]))
    for i = 1:length(dataStr)
        data[i,:] = map(x -> parse(Int, x), split(dataStr[i],""))
    end

    return data
end

function StepData!(data::Matrix)
    # need to do slicing to modify data in place
    data[:,:] += ones(Int, size(data)...)

    flashes = findall(x -> x == 10, data)
    while ! isempty(flashes)
        newFlashes = Array{CartesianIndex{2},1}(undef, 0)
        
        for flash in flashes
            x, y = flash[1], flash[2]
            xMin, xMax = x == 1 ? x : x-1, x == size(data)[1] ? x : x+1
            yMin, yMax = y == 1 ? y : y-1, y == size(data)[2] ? y : y+1
            data[xMin:xMax, yMin:yMax] += ones(Int, xMax-xMin+1, yMax-yMin+1)

            for i=xMin:xMax, j=yMin:yMax
                if data[i,j] == 10
                    push!(newFlashes, CartesianIndex(i,j))
                end
            end
        end
        
        flashes = newFlashes
    end
    
    map!(x -> x>=10 ? 0 : x, data, data)
end

function Part1(data::Matrix)
    nSteps = 100
    flashes = 0

    for i = 1:nSteps
        StepData!(data)
        flashes += count(iszero, data)
    end

    return flashes
end


function Part2(data::Matrix)
    steps = 0
    while ! all(iszero, data)
        StepData!(data)
        steps += 1
    end

    return steps
end
    

#datafile = "../data/test11.txt"
datafile = "../data/day11.txt"

data = ReadData(datafile)
println(Part1(data))


# need to re-read data since Part1 modifies it
data = ReadData(datafile)
println(Part2(data))
