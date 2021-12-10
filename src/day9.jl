using DelimitedFiles

function ReadData(fname::AbstractString)
    dataStr = readdlm(fname, String)

    data = zeros(Int, length(dataStr), length(dataStr[1]))
    for i = 1:length(dataStr)
        data[i,:] = map(x -> parse(Int, x), split(dataStr[i],""))
    end

    return data
end


function FindMinima(data::Matrix)
    vOffsetU = circshift(data, (-1,0)) # data shifted up one
    hOffsetL = circshift(data, (0,-1)) # data shifted to the left
    vOffsetD = circshift(data, (1,0))  # data shifted up one
    hOffsetR = circshift(data, (0,1))  # data shifted to the left

    # set the edges to be 9 (the maximum possible value)
    vOffsetU[size(data)[1],:] = fill(9, size(data)[2])
    hOffsetL[:,size(data)[2]] = fill(9, size(data)[1])
    vOffsetD[1,:] = fill(9, size(data)[2])
    hOffsetR[:,1] = fill(9, size(data)[1])
    
    return intersect([findall(x -> x<0, data-offset) for offset in [vOffsetU, hOffsetL, vOffsetD, hOffsetR]]...)
end

function Part1(data::Matrix)
    minimaPositions = FindMinima(data) 

    minima = map(x -> getindex(data, x), minimaPositions)

    return sum(minima)+length(minima)
end

function Part2(data::Matrix)
    vOffsetU = circshift(data, (-1,0)) # data shifted up one
    hOffsetL = circshift(data, (0,-1)) # data shifted to the left
    vOffsetD = circshift(data, (1,0))  # data shifted up one
    hOffsetR = circshift(data, (0,1))  # data shifted to the left

    # set the edges to be 9 (the maximum possible value)
    vOffsetU[size(data)[1],:] = fill(9, size(data)[2])
    hOffsetL[:,size(data)[2]] = fill(9, size(data)[1])
    vOffsetD[1,:] = fill(9, size(data)[2])
    hOffsetR[:,1] = fill(9, size(data)[1])
    
    minimaPositions = intersect([findall(x -> x<0,  data-offset) for offset in [vOffsetU, hOffsetL, vOffsetD, hOffsetR]]...)
    maximaPositions = intersect([findall(x -> x>=0, data-offset) for offset in [vOffsetU, hOffsetL, vOffsetD, hOffsetR]]...) # this will catch saddle points

    basinSizes = []
    
    for x in minimaPositions
        # start building basin
        currentBasin = [x]

        basinSize = 0

        Q = [x]
        explored = [x]
        while ! isempty(Q)
            v = pop!(Q)
            if getindex(data, v) == 9
                continue
            else
                basinSize += 1
            end
            i, j = v[1], v[2]
            for k=-1:2:1
                if CartesianIndex(i+k, j) ∉ explored && 1 <= i+k <= size(data)[1]
                    push!(explored, CartesianIndex(i+k, j))
                    push!(Q, CartesianIndex(i+k, j))
                end
                
                if CartesianIndex(i, j+k) ∉ explored && 1 <= j+k <= size(data)[2]
                    push!(explored, CartesianIndex(i, j+k))
                    push!(Q, CartesianIndex(i, j+k))
                end
            end
        end

        push!(basinSizes, basinSize)
    end

    sort!(basinSizes, rev=true)
    
    return basinSizes[1]*basinSizes[2]*basinSizes[3]
                    
end

    
#data = ReadData("../data/test9.txt")
data = ReadData("../data/day9.txt")

println(Part2(data))
