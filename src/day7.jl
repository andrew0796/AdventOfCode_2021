using DelimitedFiles

function ReadData(fname::AbstractString)
    return vec(readdlm(fname, ',', Int))
end

function Median(data::Array)
    if isodd(length(data))
        x0 = sort(data)[div(length(data)-1,2)]
        x1 = sort(data)[div(length(data)+1,2)]

        return x0, x1
    else
        x0 = sort(data)[div(length(data),2)]
        return x0
    end
end

    
# the optimal position will be the median
function Part1(data::Array)
    if isodd(length(data))
        x0, x1 = Median(data)

        c0 = sum(abs(x0-x) for x in data)
        c1 = sum(abs(x1-x) for x in data)

        return min(c0, c1)
    else
        x0 = Median(data)
        return sum(abs(x0-x) for x in data)
    end
end

# the optimal position will be somewhere between the average and the median
function Part2(data::Array)
    xAvg = round(Int, sum(data)/length(data))
    xMed = isodd(length(data)) ? min(Median(data)) : Median(data)

    # search between xAvg and xMed for the minimum
    x0, x1 = min(xAvg, xMed), max(xAvg, xMed)
    cMin = sum(data)*(sum(data)+1)
    cost = x -> div(sum(abs(y-x)*(1+abs(y-x)) for y in data),2)
    for x in x0:x1
        c = cost(x)
        cMin = c < cMin ? c : cMin
    end

    return cMin
end


#data = [16,1,2,0,4,2,7,1,2,14]
data = ReadData("../data/day7.txt")

println(Part1(data))
println(Part2(data))
