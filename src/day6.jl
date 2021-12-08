using DelimitedFiles

function ReadData(fname::AbstractString)
    return readdlm(fname, ',', Int)
end

function UpdateData!(data::Array)
    for i = 1:length(data)
        if data[i] == 0
            data[i] = 6
            push!(data, 8)
        else
            data[i] = data[i] - 1
        end
    end
end


function Part1(data::Array)
    for i = 1:80
        UpdateData!(data)
    end
    return length(data)
end

function UpdateDDict!(ddict::Dict)
    oldDict = Dict([(i, ddict[i]) for i = 0:8])
    
    ddict[8] = oldDict[0]
    ddict[7] = oldDict[8]
    ddict[6] = oldDict[7] + oldDict[0]
    for i = 0:5
        ddict[i] = oldDict[i+1]
    end
end

function Part2(data::Array)
    # store data in a dictionary
    ddict = Dict([(i, count(x -> x==i, data)) for i = 0:8])
    
    for i = 1:256
        UpdateDDict!(ddict)
    end
    return sum(values(ddict))
end

data = [3, 4, 3, 1, 2]

data = vec(ReadData("../data/day6.txt"))

#println(data)

println(Part2(data))
