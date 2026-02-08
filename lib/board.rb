require_relative 'display'
require_relative 'win_detection'
class Board
  include WinDetection
  include Display
  DEFAULT_CELL_VALUE = '  '.freeze
  def initialize(board = Array.new(6) { Array.new(7) { DEFAULT_CELL_VALUE } })
    @board = board
  end

  def full?
    board.all? { |row| row.none?(DEFAULT_CELL_VALUE) }
  end

  def valid_move?(move)
    valid_column?(move) && !full_column?(move)
  end

  def full_column?(column)
    board[0][column] != DEFAULT_CELL_VALUE
  end

  def find_empty_cell_row(column)
    row = board.length - 1
    row -= 1 until board[row][column] == DEFAULT_CELL_VALUE
    row
  end

  def assign_move(move, player)
    row = move[0]
    column = move[1]
    board[row][column] = player.circle
  end

  def board_winner?(player, move)
    row = move[0]
    column = move[1]
    filtered_cords(row, column).any? do |cords|
      cords.all? { |cord| board[cord[0]][cord[1]] == player.circle }
    end
  end

  private

  include WinDetection

  def valid_row?(row)
    row.between?(0, 5) # 0 lowest row number available, 5 highest row number available within the board
  end

  def valid_column?(column)
    column.between?(0, 6) # 0 lowest column number available, 6 highest column number available within the board
  end

  attr_reader :board
end
