require_relative 'display'
class Board
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

  def filtered_cords(row, column)
    cords = (four_column_cords(row, column) + four_row_cords(row, column) +
          four_diagonal_cords(row, column) + four_diagonal_cords(row, column, -3))
    cords.reject { |array| array.length < 4 }
  end

  # returns all possible winning columns from the given position(player's move)
  def four_column_cords(row, column, acc = 0)
    positive_set = []
    negative_set = []
    4.times do
      new_column = acc + column
      positive_set.push([row, new_column]) if valid_column?(new_column)
      new_column = acc * -1 + column
      negative_set.push([row, new_column]) if valid_column?(new_column)
      acc += 1
    end
    [positive_set, negative_set]
  end

  # returns all possible winning rows from the given position(player's move)
  def four_row_cords(row, column, acc = 0)
    positive_set = []
    negative_set = []
    4.times do
      new_row = acc + row
      positive_set.push([new_row, column]) if valid_row?(new_row)
      new_row = acc * -1 + row
      negative_set.push([new_row, column]) if valid_row?(new_row)
      acc += 1
    end
    [positive_set, negative_set]
  end

  # returns all possible winning diagonals from the given position(player's move)
  def four_diagonal_cords(row, column, acc = 0)
    main, left, right = Array.new(3) { [] } # creates 3 empty arrays -> main, left, right

    4.times do
      new_row = acc + row
      new_column = acc + column

      main.push([new_row, new_column]) if valid_row?(new_row) && valid_column?(new_column)
      left.push([row - acc, new_column]) if valid_row?(row - acc) && valid_column?(new_column)
      right.push([new_row, column - acc]) if valid_column?(column - acc) && valid_row?(new_row)
      acc += 1
    end

    [main, left, right]
  end

  def valid_row?(row)
    row.between?(0, 5) # 0 lowest row number available, 5 highest row number available within the board
  end

  def valid_column?(column)
    column.between?(0, 6) # 0 lowest column number available, 6 highest column number available within the board
  end

  attr_reader :board
end
