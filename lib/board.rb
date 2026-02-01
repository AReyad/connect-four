class Board
  def initialize(board = Array.new(6) { Array.new(7) })
    @board = board
  end

  def full?
    board.all? { |row| row.none?(&:nil?) }
  end

  def valid_move?(move)
    move.between?(1, 7) && !full_column?(move)
  end

  def full_column?(move)
    !board[0][move - 1].nil?
  end

  def find_empty_cell(move)
  end

  attr_reader :board
end
