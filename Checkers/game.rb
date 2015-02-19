require_relative 'board'

class Game
  attr_accessor :board
  COLORS = {:B => "Black", :R => "Red"}
  def initialize
    @board = Board.new
  end

  def play
    loop do
      turn(:B)
      break if board.won?
      turn(:R)
      break if board.won?
    end
    puts "Someone won!"
    board.render

  end

  def turn(color)
    puts "It's #{COLORS[color]}'s turn"
    board.render
    begin
      from, sequence = get_input
      if board[from].nil?
        raise IllegalMoveError.new "No piece there!"
      end
      if !board[from].valid_move_seq?(sequence)
        raise IllegalMoveError.new "Not a valid move!"
      end
      if board[from].color != color
        raise IllegalMoveError.new "That's not your piece!"
      end
    rescue IllegalMoveError => e
      puts e.message
      retry
    end
    board[from].perform_moves(sequence)
    to = sequence[-1]
    board[to].maybe_promote
  end

  def get_input
    puts "What piece do you want to move? (e.g. 1,2)"
    from = gets.chomp.split(',').map(&:to_i)
    puts "What sequence of moves do you want to make?"
    sequence = gets.chomp.split(" ").map{ |x| x.split(",").map(&:to_i) }
    [from, sequence]
  end

end



if __FILE__ == $0
 g = Game.new
 g.play
end
