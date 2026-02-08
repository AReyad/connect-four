class Player
  attr_reader :name, :circle

  def initialize(name, circle)
    @name = name
    @circle = circle
  end

  def move
    gets.chomp.to_i - 1
  end
end
