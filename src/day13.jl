using DelimitedFiles

function ReadData(fname::AbstractString)
    # need to turn on comments to skip the "fold along ..." lines at the bottom
    dotsMtx = readdlm(fname, ',', Int, '\n', comments=true, comment_char='f')
    dots = [dotsMtx[i,:] for i=1:size(dotsMtx)[1]]
    
    # read in folds
    folds = []
    open(fname, "r") do f
        readuntil(f, "f")
        line = readline(f)
        push!(folds, (line[11], parse(Int, SubString(line,13))))
        for line in eachline(f)
            push!(folds, (line[12], parse(Int, SubString(line,14))))
        end
    end

    return dots, folds
end


function Fold!(dots::Array{Array{Int,1},1}, fold)
    ndx = fold[1] == 'x' ? 1 : 2
    newDots = Array{Int,1}[]

    for i=1:length(dots)
        if fold[2] < dots[i][ndx] <= 2*fold[2]
            dots[i][ndx] = 2*fold[2] - dots[i][ndx]
            if count(x -> x == dots[i], newDots) == 0
                push!(newDots, dots[i])
            end
        elseif dots[i][ndx] < fold[2]
            if count(x -> x == dots[i], newDots) == 0
                push!(newDots, dots[i])
            end
        end
    end

    return newDots
end

    
function Part1(dots::Array{Array{Int,1},1}, folds::Array)
    return length(Fold!(dots, folds[1]))
end

function Part2(dots::Array{Array{Int,1},1}, folds::Array)
    for fold in folds
        dots = Fold!(dots, fold)
    end

    grid = fill(" ", max([x[1] for x in dots]...)+1, max([x[2] for x in dots]...)+1)

    foreach(x -> grid[x[1]+1, x[2]+1] = "#", dots)

    foreach(x -> println(join(grid[:,x], "")), 1:size(grid)[2])
end


#dataFile = "../data/test13.txt"
dataFile = "../data/day13.txt"

data, folds = ReadData(dataFile)
println(Part1(data, folds))


data, folds = ReadData(dataFile)
Part2(data, folds)
