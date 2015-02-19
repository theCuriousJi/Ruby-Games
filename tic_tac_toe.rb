class Game

  attr_accessor :board
  def initialize(player1,player2)
    @board = Board.new
    @player1 = player1
    @player2 = player2
  end

  def render
    @board.display
  end

  def move(player)
    loop do
      player.get_move(self)
      break if board.empty?(player.pos) == true
      puts "Not a valid move!"
    end
    @board.place_mark(player.pos, player.mark)
  end


  def play
    loop do
      render
      move(@player1)
      render
      move(@player2)
    end
  end


end
class Board
  attr_accessor :board

  def initialize
    @board = @board = Array.new(3) {Array.new(3, " ")}
  end
  def display
    puts "\n"
    puts "    1   2   3"
    0.upto(board.length - 1) do |row|
        puts "#{row + 1}   #{board[row].join(" | ")}"
        puts "    ---------" unless row == 2
    end
  end


  def empty?(pos)
    x, y = pos
    return true if board[x][y] == " "
    false
  end

  def place_mark(pos, mark)
    x, y = pos
    board[x][y] = mark
  end

  def rows
    @board
  end

  def cols
    cols = Array.new(3) {Array.new(3,"")}
    0.upto(2) do |i|
      0.upto(2) do |j|
        cols[j][i] = @board[i][j]
      end
    end
    cols
  end

  def diags
    diags1 = [@board[0][0],@board[1][1],@board[2][2]]
    diags2 = [@board[2][0], @board[1][1], @board[0][2]]
  end

  def won?

  end

end

class Human

  attr_accessor :pos, :mark

  def initialize(mark)
    @mark = mark
  end

  def get_move(game)
    puts "Where would you like to move? (row, column e.g. 1,2)"
    @pos = gets.chomp.split(",")
    @pos = @pos.map {|x| x.to_i - 1}
  end
end

class Computer
  attr_accessor :pos, :mark
  def initialize(mark)
    @mark = mark
  end

  def get_move(game)
    winner_move || random_move
  end

  def winner_move(game)
    rows = game.board.rows
    cols = game.board.cols
    diag1 = game.board.diag1
    diag2 = game.board.diag2
    pos = nil
      rows.each_with_index do |row, idx|
        if row.count(mark) == 2 && diag.count(" ") == 1
          pos = [idx, row.index(" ")]
          return pos
        end
      end

      cols.each_with_index do |col, idx|
        if col.count(mark) == 2 && diag.count(" ") == 1
          pos = [idx, col.index(" ")]
          return pos
        end
      end
        if diag1.count(mark) == 2 && diag1.count(" ") == 1
          pos = [diag1.index(" "), diag1.index(" ")]
        end

        if diag2.count(mark) == 2 && diag2.count(" ") == 1
          case diag2.index(" ")
          when 0
            pos = [2,0]
          when 1
            pos = [1,1]
          when 2
            pos = [0,2]
          end
        end
        pos
  end

  def random_move
    x = (0..2).to_a.sample
    y = (0..2).to_a.sample
    @pos = [x,y]
  end
end
b = Human.new("X")
c = Computer.new("O")
game = Game.new(b,c)
game.board.rows
p game.board.diags
