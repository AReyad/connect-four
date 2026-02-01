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

  def find_empty_cell_row(column)
    row = board.length - 1
    row -= 1 until board[row][column].nil?
    row
  end

  def assign_move(move, player)
    column = move - 1
    row = find_empty_cell_row(column)
    board[row][column] = player.circle
  end

  private

  attr_reader :board
end
