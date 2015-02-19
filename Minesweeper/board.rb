require_relative 'tile'
class Board
  attr_accessor :board_size, :bombs, :grid, :reveal

  def initialize(board_size, bombs)
    @board_size = board_size
    @bombs = bombs
    @revealed = false
    generate_board
  end

  def generate_board
    @grid = Array.new(board_size) do |row|
      Array.new(board_size) { |col|  Tile.new(self, [row, col]) }
    end
    place_bombs
  end

  def place_bombs
    bomb_locations = populate_bombs
      bomb_locations
    bomb_locations.each do |pos|
      self[pos].bombed = true
    end
  end

  def [](pos)
    x,y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x,y = pos
    @grid[x][y] = value
  end

  def render
    num = 0
    puts "\n"
    (0..board_size - 1).each do |num|
      print "  #{num}"
    end
    puts "\n"
    @grid.each_with_index do |row, idx|
      print idx
      row.each do |tile|
        print " #{tile.render} "
      end
      puts "\n"
    end
  end

  def populate_bombs
    bomb_locations = []
    until bomb_locations.count == bombs
      x,y = rand(board_size), rand(board_size)
      bomb_locations << [x,y] if !bomb_locations.include?([x,y])
    end

    bomb_locations
  end
end
#
# b = Board.new(10, 20)
# b.render
# # p b[[1,1]].bombed = true
#
# # p b[[1,2]].neighbors
