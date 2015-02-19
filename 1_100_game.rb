class Game
  def initialize
    @comp = (1..100).to_a.sample
  end

  def play
    count = 0
  loop do
    guess = get
    result = guess <=> @comp
    case result
      when -1
        puts " Too low \n"
        count += 1
      when 0
        puts "That's it! You got it in #{count + 1} guesses!"
        break
      when 1
        puts "Too high \n"
        count += 1
      end

  end
end


  def get
    guess = 0
    until guess.between?(1,100)  do
      puts "Guess my number. It's between 1 and 100"
      guess = gets.chomp.to_i
    end
    guess
  end
end
a= Game.new
a.play
