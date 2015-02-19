class Code
  attr_reader :pegs
  PEGS = {
    "B" => :blue,
    "G" => :green,
    "O" => :orange,
    "P" => :purple,
    "R" => :red,
    "Y" => :yellow
  }

  def initialize(pegs)
    @pegs = pegs
  end

  def self.random
    pegs = []
    4.times {pegs << PEGS.values.sample}
    Code.new(pegs)
  end

  def self.parse(input)
    letters = input.split("")
    symbols = letters.map {|letter| PEGS[letter]}
    Code.new(symbols)
  end

  def exact_match(guess)
    exact_matches = 0
    (0..3).each do |index|
      exact_matches += 1 if @pegs[index] == guess.pegs[index]
    end
    exact_matches
  end

  def near_match(guess)
    guess_color_count = guess.color_count

    my_count = self.color_count
    near_matches = 0

    guess_color_count.each do |k, v|
      if my_count.has_key?(k)
        near_matches += [my_count[k], v].min
      end
    end
    near_matches = near_matches - self.exact_match(guess)
  end

  def color_count
    color_counts = Hash.new {|h,k| h[k] = 0}
    @pegs.each do |el|
      color_counts[el] += 1
    end
    color_counts
  end



end

class Game
  MAX_TURNS = 10
  attr_accessor :correct_code
  def initialize
    @correct_code = Code.random
  end

  def prompt
    begin
      Code.parse(gets.chomp)
    rescue
      puts "Error parsing code!"
      retry
    end
  end

  def play
    MAX_TURNS.times do
      puts "\n"
      puts "Make a guess"
      guess = prompt
      if correct_code.pegs == guess.pegs
        puts "You Win!"
        return
      end
      puts "Exact Matches: #{@correct_code.exact_match(guess)}"
      puts "Near Matches: #{@correct_code.near_match(guess)}"
    end

    puts "\n"
    puts "You lose"
  end

end

a = Game.new
a.play
