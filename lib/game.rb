require_relative 'player'
require_relative 'board'
require_relative 'display'
require 'colorize'

class Game
  def initialize(board = Board.new, player1 = create_player("\u{1F535}", 1, :blue),
                 player2 = create_player("\u{1F534}", 2, :red))
    @board = board
    @player1 = player1
    @player2 = player2
  end

  def create_player(symbol, number, color)
    puts "Enter player #{number}'s name with at least one character: "
    name = gets.chomp while invalid_name?(name)
    Player.new(name.colorize(color), symbol)
  end

  private

  def invalid_name?(name)
    name.nil? || name.empty?
  end

  attr_reader :player1, :player2, :board
end

Board.new.display_board
