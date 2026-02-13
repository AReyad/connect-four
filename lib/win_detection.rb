module WinDetection
  POSSIBLE_WINNING_POSITIONS = [[0, 1, 2, 3], [0, -1, -2, -3], [0, 1, 2, -1], [0, -1, -2, 1]].freeze

  def filtered_coords(row, column)
    coords = column_coords(row, column) + row_coords(row, column) + diagonal_coords(row, column)
    coords.reject { |array| array.length < 4 }
  end

  # returns all possible winning columns from the given position(player's move)
  def column_coords(row, column)
    result = []
    POSSIBLE_WINNING_POSITIONS.each do |positions|
      coords_array = []
      positions.each do |position|
        new_col = position + column
        coords_array << [row, new_col] if valid_column?(new_col)
      end
      result << coords_array
    end
    result
  end

  # returns all possible winning rows from the given position(player's move)
  def row_coords(row, column)
    result = []
    POSSIBLE_WINNING_POSITIONS.each do |positions|
      coords_array = []
      positions.each do |position|
        new_row = position + row
        coords_array << [new_row, column] if valid_row?(new_row)
      end
      result << coords_array
    end
    result
  end

  # returns all possible winning diagonals from the given position(player's move)
  def diagonal_coords(row, column)
    result = []

    POSSIBLE_WINNING_POSITIONS.each do |positions|
      main, offset = Array.new(2) { [] } # creates 2 empty arrays -> for main diagonals, and offset diagonals
      positions.each do |pos|
        new_row = pos + row
        new_column = pos + column

        main.push([new_row, new_column]) if valid_row?(new_row) && valid_column?(new_column)
        offset.push([row - pos, new_column]) if valid_row?(row - pos) && valid_column?(new_column)
      end
      result.push(main, offset)
    end
    result
  end
end
