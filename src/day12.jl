using DelimitedFiles

function ReadData(fname::AbstractString)
    dataMtx = readdlm(fname, '-', String, '\n')

    data = Dict([(x, String[]) for x in dataMtx])
    for i=1:size(dataMtx)[1]
        push!(data[dataMtx[i,1]], dataMtx[i,2])
        push!(data[dataMtx[i,2]], dataMtx[i,1])
    end
        
    return data
end

function FindPaths1(data::Dict, start::String, path::Array{String,1})
    paths = Array{String,1}[]
    for node in data[start]
        if all(islowercase, node) && node in path
            continue
        elseif node == "end"
            push!(paths, cat(path, node, dims=1))
        else
            foreach(x -> push!(paths, x), FindPaths1(data, node, cat(path, node, dims=1)))
        end
    end

    return paths
end

# count the maximum number of times any single lower case node appears in path
function CountMaxLower(path::Array{String,1})
    return max( map(x -> count(y -> y==x, path), filter(z -> all(islowercase, z), path))...)
end

function FindPaths2(data::Dict, start::String, path::Array{String,1})
    paths = Array{String,1}[]
    for node in data[start]
        if node == "start" && length(path) > 0
            continue
        elseif node == "end"
            push!(paths, cat(path, node, dims=1))
        elseif all(islowercase, node) && CountMaxLower(path) == 2 && node in path
            continue
        else
            foreach(x -> push!(paths, x), FindPaths2(data, node, cat(path, node, dims=1)))
        end
    end

    return paths
end

function Part1(data)
    return length(FindPaths1(data, "start", ["start"]))
end

function Part2(data)
    return length(FindPaths2(data, "start", ["start"]))
end

                  
#dataFile = "../data/test12.txt"
dataFile = "../data/day12.txt"
data = ReadData(dataFile)

println(Part1(data))
println(Part2(data))
        
