using DelimitedFiles

function ReadData(fname::AbstractString)
    data = readdlm(fname, '|', String, '\n')

    entries = []
    for i = 1:size(data)[1]
        push!(entries, (split(data[i,1], " ", keepempty=false), split(data[i,2], " ", keepempty=false)))
    end

    return entries
end


# 0 : abc efg  -> 6
# 1 :   c  f   -> 2
# 2 : a cde g  -> 5
# 3 : a cd fg  -> 5
# 4 :  bcd f   -> 4
# 5 : ab d fg  -> 5
# 6 : ab defg  -> 6
# 7 : a c  f   -> 3
# 8 : abcdefg  -> 7
# 9 : abcd fg  -> 6


# 1 :   c  f   -> 2
# 7 : a c  f   -> 3
# 4 :  bcd f   -> 4
# 2 : a cde g  -> 5
# 3 : a cd fg  -> 5
# 5 : ab d fg  -> 5
# 0 : abc efg  -> 6
# 6 : ab defg  -> 6
# 9 : abcd fg  -> 6
# 8 : abcdefg  -> 7


# intersection of 0, 6, 9, 1 = "f"
# 0 : abc efg  -> 6
# 1 :   c  f   -> 2
# 6 : ab defg  -> 6
# 9 : abcd fg  -> 6

# difference between 7 and 1 = "a"
# 7 : a c  f   -> 3
# 1 :   c  f   -> 2

# difference between 1 and "f" = "c"

# intersection of all length >= 5 codes  = "ag"
# 2 : a cde g  -> 5
# 3 : a cd fg  -> 5
# 5 : ab d fg  -> 5
# 0 : abc efg  -> 6
# 6 : ab defg  -> 6
# 9 : abcd fg  -> 6
# 8 : abcdefg  -> 7

# difference between "ag" and "a" = g

# intersection of all length 5 codes with 4 = "d"
# 4 :  bcd f   -> 4
# 2 : a cde g  -> 5
# 3 : a cd fg  -> 5
# 5 : ab d fg  -> 5


# intersection of all length 6 codes with 4 = "bf"
# 4 :  bcd f   -> 4
# 0 : abc efg  -> 6
# 6 : ab defg  -> 6
# 9 : abcd fg  -> 6

# difference between "bf" and "f" = b

# e is just the other character

digitLengths = Dict([(0,6), (1,2), (2,5), (3,5), (4,4), (5,5), (6,6), (7,3), (8,7), (9,6)])

function SortString(s::AbstractString)
    return join(sort(split(s, "")), "")
end

function DecodeSignal(signal::Array)
    # dictionary of the coded digits
    code = Dict([(i,"") for i in [1,4,7,8]])
    
    
    for i in [1,4,7,8]
        code[i] = signal[findfirst(x -> length(x)==digitLengths[i], signal)]
    end

    charCode = Dict()

    charCode["a"] = StringSetDiff([code[7], code[1]])[1]
    charCode["f"] = StringIntersection(push!(filter(x -> length(x) == 6, signal), code[1]))[1]
    charCode["c"] = StringSetDiff([code[1], charCode["f"]])[1]

    # temp is the code for "ag"
    temp = join(StringIntersection(filter(x -> length(x) >= 5, signal)), "")
    charCode["g"] = StringSetDiff([temp, charCode["a"]])[1]
    
    charCode["d"] = StringIntersection(push!(filter(x -> length(x) == 5, signal), code[4]))[1]

    # temp is the code for "bf"
    temp = join(StringIntersection(push!(filter(x -> length(x) == 6, signal), code[4])), "")
    charCode["b"] = StringSetDiff([temp, charCode["f"]])[1]
    
    charCode["e"] = StringSetDiff(["abcdefg", join(values(charCode), "")])[1]

    code[0] = join([charCode[i] for i in ["a","b","c","e","f","g"]], "")
    code[2] = join([charCode[i] for i in ["a","c","d","e","g"]], "")
    code[3] = join([charCode[i] for i in ["a","c","d","f","g"]], "")
    code[5] = join([charCode[i] for i in ["a","b","d","f","g"]], "")
    code[6] = join([charCode[i] for i in ["a","b","d","e","f","g"]], "")
    code[9] = join([charCode[i] for i in ["a","b","c","d","f","g"]], "")

    # decoded digits
    decoded = Dict([(SortString(code[i]),i) for i=0:9])
            
    return decoded
end

# get the union of an array of strings
function StringUnion(strings::Array)
    return map(String, union([split(s, "") for s in strings]...))
end

# get the intersection of an array of strings
function StringIntersection(strings::Array)
    return map(String, intersect([split(s, "") for s in strings]...))
end

# get the set difference of an array of strings
function StringSetDiff(strings::Array)
    return map(String, setdiff([split(s, "") for s in strings]...))
end


function Part1(entries::AbstractArray)
    counter = 0
    for e in entries
        counter += count(x -> length(x) in [2,3,4,7], e[2])
    end

    return counter
end

function Part2(entries::AbstractArray)
    total = 0

    for e in entries
        decoded = DecodeSignal(e[1])
        
        for i=1:4
            total += decoded[SortString(String(e[2][i]))]*10^(4-i)
        end
    end

    return total
end

data = ReadData("../data/test8.txt")
data = ReadData("../data/day8.txt")


println(Part1(data))
println(Part2(data))
