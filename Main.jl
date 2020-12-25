import Base: convert, print

struct piece
    x::Int64
    y::Int64
    type::String
end

mutable struct gameBoard
    board::Array
    width::Int
    height::Int
end

width = 7
height = 6

convert(::Type{piece}, x::Int8) = piece(0,0,"-")
piece(x::Int8) = piece(0,0,"-")
piece(x::piece) = piece(x.x, x.y, x.type)

function createBoard(height, width)::gameBoard
    game = gameBoard(zeros(Int8, height, width), width, height)
    game.board = piece.(game.board)
    for j = 1:game.height
        for i = 1:game.width
            game.board[j,i] = piece(j,i, "-")
        end
    end
    return game
end

function printBoard(board::gameBoard)
    for k = 1:width
        print(k, "  ")
    end
    println(" ")
    println(" ")
    for j = 1:board.height
        for i = 1:board.width
            print(board.board[j,i].type, "  ")
        end
        println(" ")
    end
end

function main()

    player = "X"

    function quit()
        println("What is your command? Type quit to quit. Type a number of a column to drop a piece.")
        input = readline()
        if !isempty(input)
            if input == "quit"
                println("Thanks for playing!")
                playing = false
            end
            for x = 1:board.width
                if parse(Int64, input) == x
                    dropPiece(x, player);
                end
            end
        else 
            println("You didn't type anything!")
        end
    end

    function switchPlayer()
        if player == "X"
            player = "O"
        else 
            player = "X"
        end
    end
    
    function dropPiece(x, player)
        for i = 1:board.height
            if board.board[1, x].type != "-"
                println("Column is full try another")
                break
            elseif board.board[board.height - i+1,x].type == "-"
                board.board[board.height - i+1,x] = piece(i,x,player)
                switchPlayer()
                break
            end 
        end
    end

    function 
    
    playing = true
    board = createBoard(height, width)

    while playing
        printBoard(board)
        println("It is player: ", player, "'s turn.")
        quit()
    end
end


main()
