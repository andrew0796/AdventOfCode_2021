function ReadData(fname::AbstractString)
    lines = []

    xMax, xMin = 0, 1
    yMax, yMin = 0, 1
    
    for line in eachline(fname)
        push!(lines, map(y-> map(x -> parse(Int, x), split(y, ",")), split(line, " -> ")))

        x0, y0 = lines[length(lines)][1]
        x1, y1 = lines[length(lines)][2]

        if min(x0, x1) < xMin
            xMin = min(x0, x1)
        end
        if max(x0, x1) > xMax
            xMax = max(x0, x1)
        end
        if min(y0, y1) < yMin
            yMin = min(y0, y1)
        end
        if max(y0, y1) > yMax
            yMax = max(y0, y1)
        end
    end

    return lines, (xMin, xMax), (yMin, yMax)
end

function IsVertical(line::Array)
    return line[1][1] == line[2][1]
end

function IsHorizontal(line::Array)
    return line[1][2] == line[2][2]
end

function IsDiagonal(line::Array)
    return abs(line[1][1]-line[2][1]) == abs(line[1][2]-line[2][2])
end

function Part1(data)
    lines = data[1]
    xMin, xMax = data[2]
    yMin, yMax = data[3]
    
    grid = zeros(Int, yMax+1, xMax+1)

    for line in lines
        if IsVertical(line)
            y0, y1 = 0, 0
            if line[1][2] > line[2][2]
                y0, y1 = line[2][2], line[1][2]
            else
                y0, y1 = line[1][2], line[2][2]
            end
            
            grid[(y0+1):(y1+1), line[1][1]+1] += fill(1, y1-y0+1)
        end

        if IsHorizontal(line)
            x0, x1 = 0, 0
            if line[1][1] > line[2][1]
                x0, x1 = line[2][1], line[1][1]
            else
                x0, x1 = line[1][1], line[2][1]
            end

            grid[line[1][2]+1, (x0+1):(x1+1)] += fill(1, x1-x0+1)
        end
    end

    #for i in 1:(yMax+1)
    #    println(grid[i,:])
    #end
    
    return count(x -> x>=2, grid)
end

function Part2(data)
    lines = data[1]
    xMin, xMax = data[2]
    yMin, yMax = data[3]
    
    grid = zeros(Int, yMax+1, xMax+1)

    for line in lines
        if IsVertical(line)
            y0, y1 = 0, 0
            if line[1][2] > line[2][2]
                y0, y1 = line[2][2], line[1][2]
            else
                y0, y1 = line[1][2], line[2][2]
            end
            
            grid[(y0+1):(y1+1), line[1][1]+1] += fill(1, y1-y0+1)

        elseif IsHorizontal(line)
            x0, x1 = 0, 0
            if line[1][1] > line[2][1]
                x0, x1 = line[2][1], line[1][1]
            else
                x0, x1 = line[1][1], line[2][1]
            end

            grid[line[1][2]+1, (x0+1):(x1+1)] += fill(1, x1-x0+1)

        else
            x0, x1 = line[1][1], line[2][1]
            y0, y1 = line[1][2], line[2][2]

            dx = x1 > x0 ? 1 : -1
            dy = y1 > y0 ? 1 : -1

            for i = 0:(abs(x1-x0))
                grid[y0 + dy*i + 1, x0 + dx*i + 1] += 1
            end
        end
        
    end

    #for i in 1:yMax+1
    #    println(grid[i,:])
    #end
    

    return count(x -> x>=2, grid)
end


#data = ReadData("../data/test5.txt")
data = ReadData("../data/day5.txt")

#println(Part1(data))
println(Part2(data))

# 0,0 -> 8,8
# 8,0 -> 0,8
# NOT 6,4 -> 2,0
