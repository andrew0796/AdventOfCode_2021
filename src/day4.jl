using DelimitedFiles

function ReadData(fname::AbstractString)
    numbersCalled = []
    boards = []
    
    open(fname, "r") do f
        numbersCalled = map(x -> parse(Int, x), split(readline(f), ","))

        # skip the empty line
        readline(f)

        while !eof(f)
            currentBoard = zeros(Int, 5,5)

            for i=1:5
                currentBoard[i,:] = map(x -> parse(Int, x), split(readline(f), " ", keepempty=false))
            end

            push!(boards, currentBoard)

            readline(f)
        end
    end

    return numbersCalled, boards
    
end

function WinningBoard(board::Matrix)
    # a board has won when any row/column sums to -5 (after matching entries are set to -1)
    for i = 1:5
        if sum(board[i,:]) == -5 || sum(board[:,i]) == -5
            return true
        end
    end
    return false
end

function UpdateBoard!(board, numberCalled)
    # when a number is called, set any matching board elements to -1
    ndx = findfirst(x -> x==numberCalled, board)
    if ndx != nothing
        setindex!(board, -1, ndx)
    end
end

function Part1(data)
    numbersCalled, boards = data

    winner = nothing
    ndx = 0
    while winner == nothing
        ndx += 1
        map(b -> UpdateBoard!(b, numbersCalled[ndx]), boards)
        winner = findfirst(WinningBoard, boards)
    end


    winningBoard = boards[winner]
    return (sum(winningBoard) + count(x -> x==-1, winningBoard)) * numbersCalled[ndx]
end


function Part2(data)
    numbersCalled, boards = data

    lastWinner = zeros(Int, 5,5)
    lastNumber = -1
    ndx = 0
    while ndx < length(numbersCalled)
        winner = nothing
        while winner == nothing && ndx < length(numbersCalled)
            ndx += 1
            map(b -> UpdateBoard!(b, numbersCalled[ndx]), boards)
            winner = findfirst(WinningBoard, boards)
        end

        if winner != nothing
            lastWinner = boards[winner]
            lastNumber = numbersCalled[ndx]
            filter!(x -> !WinningBoard(x), boards)
        end
    end

    return (sum(lastWinner) + count(x -> x==-1, lastWinner)) * lastNumber
end

    
data = ReadData("../data/test4.txt")
data = ReadData("../data/day4.txt")

println(Part1(data))

println(Part2(data))
