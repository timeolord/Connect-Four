import Base: convert, print
#using Flux
#using ReinforcementLearningBase

struct Piece
    x::Int64
    y::Int64
    type::String
end

mutable struct GameBoard
    board::Union{Array{Piece}, Array{Int8}}
    width::Int
    height::Int
end

width = 7
height = 6

convert(::Type{Piece}, x::Int8) = Piece(0,0,"-")
Piece(x::Int8) = Piece(0,0,"-")
Piece(x::Piece) = Piece(x.x, x.y, x.type)

function createBoard(height, width)::GameBoard
    game = GameBoard(zeros(Int8, height, width), width, height)
    game.board = Piece.(game.board)
    for j = 1:game.height
        for i = 1:game.width
            game.board[j,i] = Piece(i,j, "-")
        end
    end
    return game
end

function printBoard(board::GameBoard)
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

    function inputf()
        println("What is your command? Type quit to quit. Type a number of a column to drop a Piece.")
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
                board.board[board.height - i+1,x] = Piece(x,board.height - i+1,player)
                switchPlayer()
                break
            end 
        end
    end

    function checkWin()
        for i in board.board
            if i.type != "-"
                #println(i.y, i.x)
                checkWin(i)
            end
        end
    end

    function checkWin(x::Piece)
        #horizontal to right
        if x.x + 3 < board.height
            if board.board[x.y, x.x].type == x.type &&
                board.board[x.y, x.x + 1].type == x.type &&
                board.board[x.y, x.x + 2].type == x.type &&
                board.board[x.y, x.x + 3].type == x.type
                win = true
            end
        end

        #vertical
        if x.y - 3 < board.height && x.y - 3 > 0 
            if board.board[x.y, x.x].type == x.type &&
                board.board[x.y - 1, x.x].type == x.type &&
                board.board[x.y - 2, x.x].type == x.type &&
                board.board[x.y - 3, x.x].type == x.type
                win = true
            end
        end

        #diagonal right up
        if x.y + 3 < board.height && x.x + 3 < board.width
            if board.board[x.y, x.x].type == x.type &&
                board.board[x.y + 1, x.x + 1].type == x.type &&
                board.board[x.y + 2, x.x + 2].type == x.type &&
                board.board[x.y + 3, x.x + 3].type == x.type
                win = true
            end
        end

        #diagonal right down
        if x.y - 3 < board.height && x.y - 3 > 0 && x.x + 3 < board.width
            if board.board[x.y, x.x].type == x.type &&
                board.board[x.y - 1, x.x + 1].type == x.type &&
                board.board[x.y - 2, x.x + 2].type == x.type &&
                board.board[x.y - 3, x.x + 3].type == x.type
                win = true
            end
        end

    end

    function checkTie()
        ties = Int64[]
        for x = 1:board.width
            if board.board[1, x].type != "-"
                push!(ties, 1)
            end
        end
        if length(ties) == width
            tie = true
        end
    end

    #ReinforcementLearningBase.get_actions(env::ConnectEnv) = (:1,:2,:3,:4,:5,:6,:7)
    #ReinforcementLearningBase.get_state(env::ConnectEnv) = !isnothing(env.reward)
    #ReinforcementLearningBase.get_terminal(env::ConnectEnv) = !isnothing(env.reward)
    #ReinforcementLearningBase.reset!(env::ConnectEnv) = env.reward = nothing

    win = false
    playing = true
    tie = false
    board = createBoard(height, width)

    

    while playing
        printBoard(board)
        println("It is player ", player, "'s turn.")
        inputf()
        printBoard(board)
        checkWin()
        if win
            switchPlayer()
            println("Player ", player, " won!")
            playing = false
        end
        checkTie()
        if tie
            println("Tie Game, no one wins.")
            playing = false
        end
    end
end


#mutable struct ConnectEnv <: AbstractEnv
#    reward::Union{Nothing, Int}
#end

#ConnectEnv() = ConnectEnv(nothing)





main()
