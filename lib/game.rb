require_relative 'player'
require_relative 'board'
require_relative 'display'
require 'colorize'

class Game
  include Display
  def initialize(board = Board.new, player1 = create_player("\u{1F535}", 1, :blue),
                 player2 = create_player("\u{1F534}", 2, :red))
    @board = board
    @players = [@player1 = player1, @player2 = player2]
    @current_player = randomize_first_turn
    @winner = nil
  end

  def run
    starter_display(board)
    play
    final_message
  end

  def play
    until game_over?
      player_turn_msg
      column = player_input
      row = board.find_empty_cell_row(column)
      board.assign_move([row, column], current_player)
      circle_placed(column)
      board.display_board
      check_and_assign_winner([row, column])
      switch_player
    end
  end

  def create_player(symbol, number, color)
    create_name_msg(number)
    name = gets.chomp while invalid_name?(name)
    Player.new(name.capitalize.colorize(color), symbol)
  end

  def player_input
    move = current_player.move
    until board.valid_move?(move)
      invalid_input_msg
      move = current_player.move
    end
    move
  end

  def switch_player
    players.rotate!
    self.current_player = players[0]
  end

  def game_over?
    !winner.nil? || board.full?
  end

  private

  def check_and_assign_winner(move)
    self.winner = current_player if board.board_winner?(current_player, move)
  end

  def randomize_first_turn
    players.shuffle![0]
  end

  def invalid_name?(name)
    name.nil? || name.empty?
  end

  attr_reader :player1, :player2, :board, :players

  attr_accessor :current_player, :winner
end
