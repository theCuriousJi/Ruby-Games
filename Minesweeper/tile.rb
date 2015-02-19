class Tile
  MOVES = [
    [1,0],
    [1,1],
    [1,-1],
    [0,-1],
    [-1,0],
    [0,1],
    [-1,-1],
    [-1,1]
  ]
  attr_accessor :pos, :board, :bombed, :explored, :flagged

  def initialize(board, pos)
    @board = board
    @pos = pos
    @bombed = false
    @explored = false
    @flagged = false
  end

  def bombed?
    @bombed
  end

  def explored?
    @explored
  end

  def flagged?
    @flagged
  end

  def explore
    return self if explored?
    return self if flagged?
    @explored = true

    if adjacent_bomb_count == 0
      explore_neighbors(neighbors)
    end
  end

  #recursively checks adjacent squares until all neighbors are explored or touch a mine
  def explore_neighbors(neighbors)
    neighbors.each do |pos|
      row, col = pos
      next_spot = board[[row, col]]

      next if next_spot.explored? || next_spot.bombed? || next_spot.flagged?
      next_spot.explored = true if next_spot.adjacent_bomb_count >= 0

      if next_spot.adjacent_bomb_count == 0
        next_spot.explore_neighbors(next_spot.neighbors)
      end
    end
  end

  def neighbors
    neighbors = []
    MOVES.each do |row, col|
      next_spot = pos[0] + row, pos[1] + col
      if next_spot.all? { |coord| coord.between?(0, board.board_size-1)}
        neighbors << next_spot
      end
    end
    neighbors
  end

  def adjacent_bomb_count
    neighboring_bombs = 0
    neighbors.each do |tile_pos|
      neighboring_bombs += 1 if board[tile_pos].bombed?
    end

    neighboring_bombs
  end

  def toggle_flag
    @flagged == true ?  @flagged = false : @flagged = true
  end


  def render
    if board.reveal == true
      if !bombed?
        if adjacent_bomb_count > 0
          "#{adjacent_bomb_count}"
        else
          "_"
        end
      elsif bombed? && explored?
        "X"
      elsif bombed?
        "B"

      end

    else
      if explored?
        if adjacent_bomb_count > 0
          "#{adjacent_bomb_count}"
        else
          "_"
        end
      elsif flagged?
        "F"
      elsif !explored?
        "*"
      end
    end
  end

  def inspect
    flagged?
  end
end
