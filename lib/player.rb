class Player
  def initialize(name, circle)
    @name = name
    @circle = circle
  end

  def move
    gets.chomp.to_i
  end
end
