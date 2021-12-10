using DelimitedFiles

function ReadData(fname::AbstractString)
    data = readdlm(fname, String)
    return data
end

# useful constants
const openers = ['(', '[', '{', '<']
const closers = Dict([(')','('), (']','['), ('}','{'), ('>','<')])
const errorScores  = Dict([(')',3), (']',57), ('}',1197), ('>',25137)])
const incomScores  = Dict([('(',1), ('[',2),  ('{',3),    ('<',4)])

function Part1(data)
    score = 0
    for line in data
        stack = []
        for c in line
            if c in openers
                pushfirst!(stack, c)
            else
                o = popfirst!(stack)
                if closers[c] != o
                    score += errorScores[c]
                    break
                end
            end
        end
    end

    return score
end

function Part2(data)
    scores = []
    for line in data
        stack = []
        skipline = false
        for c in line
            if c in openers
                pushfirst!(stack, c)
            else
                o = popfirst!(stack)
                if closers[c] != o
                    skipline = true
                    break
                end
            end
        end

        if !skipline && length(stack) > 0
            score = 0
            while length(stack) > 0
                o = popfirst!(stack)
                score = 5*score + incomScores[o]
            end
            push!(scores, score)
        end
    end

    sort!(scores)
    return scores[div(length(scores),2) + 1]
end


#data = ReadData("../data/test10.txt")
data = ReadData("../data/day10.txt")

println(Part1(data))
println(Part2(data))
