using DelimitedFiles

function ReadData(fname::AbstractString)
    return readdlm(fname, '\n', String)
end


function Part1(data::Array)
    nDigits = length(data[1])
    nLines = length(data)
    
    # convert raw data into binary
    D = map(x -> parse(Int,x,base=2), data)

    # sums of the digits = number of 1s in each column
    S = [sum((i >> j) & 1 for i in D) for j=0:nDigits-1]

    # compute gamma
    gamma = sum(Int(S[i]>nLines/2) << (i-1) for i=1:nDigits)

    # compute epsilon
    epsilon = ~gamma & sum(1<<i for i=0:nDigits-1)

    return gamma*epsilon
end

function Part2(data::Array)
    nDigits = length(data[1])
    nLines = length(data)
    
    # convert raw data into binary, do this twice for O2 and CO2 ratings
    D_O2  = map(x -> parse(Int,x,base=2), data)
    D_CO2 = map(x -> parse(Int,x,base=2), data)

    j = 1 # the bit we're currently working on
    while length(D_O2) > 1
        # determine most common bit
        cBit = Int(sum((i >> (nDigits-j)) & 1 for i in D_O2) >= length(D_O2)/2)
        # filter out numbers which don't have same common first bit
        D_O2 = filter(x -> ((x >> (nDigits-j)) & 1) == cBit, D_O2)
        
        j += 1
    end

    j = 1 # the bit we're currently working on
    while length(D_CO2) > 1
        # determine least common bit
        cBit = Int(sum((i >> (nDigits-j)) & 1 for i in D_CO2) < length(D_CO2)/2)
        # filter out numbers which don't have same common first bit
        D_CO2 = filter(x -> ((x >> (nDigits-j)) & 1) == cBit, D_CO2)
        
        j += 1
    end

    return D_O2[1]*D_CO2[1]
end


# test data
#data = ["00100", "11110", "10110", "10111", "10101", "01111", "00111", "11100",
#        "10000", "11001", "00010", "01010"]

data = ReadData("../data/day3.txt")


println(Part1(data))

println(Part2(data))



