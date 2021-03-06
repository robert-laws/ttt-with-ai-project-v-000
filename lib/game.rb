require 'pry'

class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [0, 1, 2], 
    [3, 4, 5], 
    [6, 7, 8], 
    [0, 3, 6], 
    [1, 4, 7], 
    [2, 5, 8], 
    [0, 4, 8], 
    [6, 4, 2]
  ]

  def initialize(player_1 = Players::Human.new('X'), player_2 = Players::Human.new('O'), board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  def current_player
    @token = (@board.turn_count % 2).zero? ? @player_1 : @player_2
  end

  def over?
    won? || draw?
  end

  def won?
    WIN_COMBINATIONS.any? do |combo|
      if position_taken?(combo[0]) && @board.cells[combo[0]] == @board.cells[combo[1]] && @board.cells[combo[1]] == @board.cells[combo[2]]
        return combo
      end
    end
  end

  def draw?
    !won? && full?
  end

  def full?
    @board.cells.all?{|square| square != ' ' }
  end

  def position_taken?(index)
    @board.cells[index] != ' '
  end

  def winner
    if combo = won?
      @board.cells[combo[0]]
    end
  end

  def turn
    puts "Please enter a number (1-9):"
    user_input = gets.strip
    index = user_input.to_i - 1
    if board.valid_move?(index)
      
    else
      turn
    end
  end

  def current_player
    @board.turn_count % 2 == 0 ? @player_1 : @player_2
  end

  def turn
    player = current_player
    current_move = player.move(@board)
    if !@board.valid_move?(current_move)
      turn
    else
      puts "Turn: #{@board.turn_count+1}\n"
      @board.display
      @board.update(current_move, player)
      puts "#{player.token} moved #{current_move}"
      @board.display
      puts "\n\n"
    end
  end

  def move(index, token)
    @board.cells[index] = player_1.token
  end

  def play
    while over? == false do
      puts "Would you like to play tic-tac-toe?"
      turn
    end
    puts winner ? "Congratulations #{winner}!" : "Cat's Game!"
  end
end