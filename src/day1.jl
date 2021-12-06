using DelimitedFiles

function ReadData(fname::AbstractString)
    return readdlm(fname, '\n', Int)
end

function CountIncreases(data::Array)
    count = 0
    for i = 1:(length(data)-1)
        count += data[i+1]>data[i]
    end

    return count
end

function CountWindowIncreases(data::Array)
    count = 0
    for i = 1:(length(data)-3)
        count += sum(data[i+1:i+3]) > sum(data[i:i+2])
    end

    return count
end


# test data
#data = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263];

# real data
data = ReadData("../data/day1.txt")


# first half
println(CountIncreases(data))

# second half
println(CountWindowIncreases(data))
