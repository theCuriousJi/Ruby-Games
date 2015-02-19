#minesweeper.rb


class Board
  def initialize(board_size)
    @board_size = board_size
    generate_board
  end

  def render
    @grid.map do |row|
      row.map do |tile|
        tile.render
      end.join(" ")
    end
  end

  def place_bombs
  end

  private
  def generate_board
    @grid = Array.new(@board_size) do |row|
      Array.new(@board_size) do |col|
        Tile.new([row,col], self)
      end
    end
  end
end

class Tile
  def initialize(pos, board)
    @board = board
    @pos = pos
  end

  def render
    if pos[0] > 2
      "B"
    else
      "*"
    end
  end

  attr_accessor :pos

end

b = Board.new(9)
puts b.render
