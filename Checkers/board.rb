require_relative 'piece'

class Board
  ODDS = [1, 3, 5, 7]
  EVENS = [0, 2, 4, 6]

  attr_accessor :grid

  def initialize(populate = true)
    generate_board(populate)
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def deep_dup
    new_board = Board.new(false)
    grid.flatten.compact.each do |piece|
      new_board[piece.pos.dup] = Piece.new(piece.pos.dup, new_board, piece.color, piece.king?)
    end
    new_board
  end

  def generate_board(populate)
    @grid = Array.new(8) { Array.new(8) }

    return unless populate == true
    [[0, 2, :R], [5, 7, :B]].each do |first, last, color|
      (first..last).each do |row|
        populate_pieces(row, color)
      end
    end
  end

  def populate_pieces(row, color)
    case row.even?
    when true
      ODDS.each { |col| self[[row,col]] = Piece.new([row, col], self, color) }
    when false
      EVENS.each { |col| self[[row,col]] = Piece.new([row, col], self, color) }
    end
  end

  def render
    num = 0
    puts "\n"
    (0..7).each { |num| print "  #{num}" }
    puts "\n"
    @grid.each do |row|
      print num
      row.each do |piece|
        if piece == nil
          print " - "
        else
          print " #{piece.render} "
        end
      end
      puts "\n"
      num += 1
    end
  end

  def won?
    return true if @grid.flatten.compact.none? { |piece| piece.color == :R}
    return true if @grid.flatten.compact.none? { |piece| piece.color == :B}
  end


end


#
# b = Board.new(false)
#
#
# b[[1,6]] = Piece.new([1,6], b, :B)
# b[[1,4]] = Piece.new([1,4], b, :R)
#
#
# # b[[0,5]].possible_moves(true)
# p b[[1,6]].perform_moves!([[0,5]])
# # b.render
#
# new_board = b.deep_dup
# p new_board[[0,5]].king
# new_board.render
# p new_board[[0,5]].perform_jump([2,3])
# # new_board[[0,5]].perform_moves([[2,3]])
# # p new_board[[0,5]].perform_slide([2,3])
# new_board.render
# a = new_board.deep_dup
# a.render
# p b[[0,5]].valid_move_seq?([[1,4]])
# b[[0,5]].perform_moves([[1,4]])
# b[[2,1]].perform_moves!([[3,2]])
# b[[5,4]].perform_moves!([[4,5]])
# b.render
# b[[3,2]].perform_moves!([[5,0]])
# b.render
#perform_moves!([[5,0]])
# b[[5,2]].perform_moves!([[4,3]])
# b[[4,3]].perform_moves!([[3,4]])
# # b[[2,5]].perform_moves!([[4,7]])
# b[[6,5]]= nil
# b.render
# # b[[2,5]].perform_moves!([[4,3], [6,5]])
# b.render
# p b[[2,5]].valid_move_seq?([[4,3], [6,5]])


# b.render
