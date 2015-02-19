class Piece
  BLACK_SLIDE = [
    [-1, 1],
    [-1, -1]
  ]

  RED_SLIDE = [
    [1, 1],
    [1, -1]
  ]

  BLACK_JUMP = [
    [-2, 2],
    [-2, -2]
  ]

  RED_JUMP = [
    [2, 2],
    [2, -2]
  ]

  attr_accessor :king, :board, :color, :pos

  def initialize(pos, board, color, king = false)
    @pos = pos
    @board = board
    @color = color
    @king = king
  end

  def king?
    @king
  end

  def valid_move_seq?(sequence)
    new_board = board.deep_dup
    if new_board[pos].perform_moves!(sequence)
      true
    else
      false
    end
  end

  def perform_moves(sequence)
    if valid_move_seq?(sequence) == false
      raise IllegalMoveError.new "Not a valid move!"
    else
      perform_moves!(sequence)
    end
  end

  def perform_moves!(sequence)
    if sequence.length == 1
      unless perform_slide(sequence[0]) ||
        perform_jump(sequence[0]) #false or true
          raise IllegalMoveError.new "Not a valid move!"
      end

    elsif sequence.length > 1
      sequence.each do |end_pos|
        return false if perform_jump(end_pos) == false #can return false or true depening on part of move
      end
    end
    true
  end

  def maybe_promote
    @king = true if color == :B && pos[0] == 0
    @king = true if color == :R && pos[0] == 7
  end

  #given a current position, where can a piece move
  def possible_moves(slide = true)
    #the slide / true false decides whether I want to look at possible sliding
    #moves or possible jumping moves and then looks in a certain part of move_dirs
    slide == true ? num = 0 : num = 1
    on_board_moves = []
    move_dirs[num].each do |row, col| # num 0 refers to sliding moves, 1 to jumps
      next_spot = pos[0] + row, pos[1] + col
      on_board_moves << next_spot if next_spot.all? { |coord| coord.between?(0,7) }
    end
    on_board_moves
  end

  def switch_piece(end_pos)
    board[end_pos], board[pos] = board[pos], nil
    board[end_pos].pos = end_pos
  end

  def perform_slide(end_pos)
    if board[end_pos].nil? && possible_moves.include?(end_pos)
      switch_piece(end_pos)
      maybe_promote
      true
    else
      false
    end
  end


  #checks to see if end spot is empty, if the piece has this move,
  #if the spot inbetween is not empty and is an enemy
  def perform_jump(end_pos)
    midpoint = (pos[0] + end_pos[0]) / 2, (pos[1] + end_pos[1]) / 2
    if !board[end_pos].nil? || !possible_moves(false).include?(end_pos)
      return false
    elsif board[midpoint].nil?
      return false
    elsif board[midpoint].color != opposite_color
      return false
    else
      switch_piece(end_pos)
      board[midpoint] = nil
      maybe_promote
      maybe_promote
      return true
    end
    false
  end


  #Returns the different directions a piece can move based on its color/status
  #jumping move is sliding move + sliding move
  def move_dirs
    if king?
      sliding_directions = BLACK_SLIDE + RED_SLIDE
      jumping_directions = BLACK_JUMP + RED_JUMP
    elsif color == :B
      sliding_directions = BLACK_SLIDE
      jumping_directions = BLACK_JUMP
    else
      sliding_directions = RED_SLIDE
      jumping_directions = RED_JUMP
    end

    [sliding_directions, jumping_directions]
  end

  def opposite_color
    color == :B ? :R : :B
  end

  def render
    if king?
      color == :B ? "♚" : "♔"
    else
      color == :B ? "⬤" : "◯"
    end
  end

  def inspect
    color
  end
end

class IllegalMoveError < StandardError
end
