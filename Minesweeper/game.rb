  require_relative 'board'

class Game

  attr_reader :board


  def initialize(board_size, bombs)
    @board = Board.new(board_size, bombs)
  end

  def play
    until won? || lost?
      turn
    end
    puts "Game Over"
  end

  def won?
    unless @board.grid.flatten.all? { |tile| tile.explored? || tile.bombed?}
      return false
    end
    puts "You win!"
    return true
  end

  def lost?
    if @board.grid.flatten.any? { |tile| tile.explored? && tile.bombed?}
      puts "You lose"
      board.reveal = true
      board.render
      return true
    end
    false
  end

  def turn
    @board.render
    move_type, pos = get_input
    if move_type == :e
      board[pos].explore
    elsif move_type == :f
      board[pos].toggle_flag
    elsif move_type == :s
      save
    elsif move_type == :q
      exit
    end
  end

  def get_input
    begin
      puts "Would you like to explore(e) or flag(f) a tile?"
      move_type = gets.chomp.to_sym
      puts "Which tile would you like to do that to?(respond with coordinates e.g. 1,2)"
      pos = gets.chomp.split(",").map(&:to_i)
      if !valid_response?(move_type, pos)
        raise InputError.new "Please try again. That input was invalid"
      end

    rescue InputError => e
      puts e.message
      retry
    end

    [move_type, pos]
  end

  def valid_response?(move_type, pos)
    # return true if move_type == :s
    return false unless [:f, :e, :q, :s].include?(move_type.downcase)
    return false unless pos.all?{ |coord| coord.between?(0, board.board_size - 1)}
    true
    #raise InputError.new "Please try again. That input was invalid"
  end

  def save
    puts "What would you like to save as?"
    filename = get_input
    File.open("#{filename}.yml", "w") { |f| f.puts self.to_yaml}
  end

  def load
  end
end

class InputError < NoMethodError
end







if __FILE__ == $PROGRAM_NAME
  "Would you like to start a new game(n) or load a game(l)"

  g = Game.new(10,20)
  g.play

end
