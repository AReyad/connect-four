module Display
  COLUMNS_LABELS = "  #{(1..7).to_a.join('    ')}".freeze

  def display_board
    puts '===================================='
    puts COLUMNS_LABELS
    board.each do |row|
      puts "| #{row.join(' | ')} |"
    end
    puts '===================================='
  end

  def invalid_input_msg
    puts '=> Invalid input, please try again!'.red
  end

  def create_name_msg(number)
    puts "Enter player #{number}'s name with at least one character: "
  end

  def player_turn_msg
    print "#{current_player.name}'s turn pick your position: "
  end

  def circle_placed(column)
    puts "=> #{current_player.name} has placed circle on column: #{column + 1}"
  end

  def final_message
    return winner_message if board.winner?(current_player)

    full_board_message
  end

  def winner_message
    puts "Player #{current_player.name} won!"
  end

  def full_board_message
    puts 'Game ended with a draw!'.yellow
  end

  def starter_display(board)
    puts ''
    puts "          +-----------------------+
          | WELCOME TO MASTERMIND |
          +-----------------------+
          ".yellow
    board.display_board
    puts '- You choose a column from 1 to 7 to place your circle'.yellow
    puts '- Your goal is to connect 4 consecutive circles in a row, column, or diagonally'.yellow
    puts 'Let the game START!'.green
    puts ''
  end
end
