class Game

  attr_accessor :display_arr, :guesser, :checker
  def initialize(guesser, checker)
    @guesser = guesser
    @checker = checker
    @display_arr = []
    @turns
  end


  def initial_display
    length = checker.word_length
    length.times do
      display_arr << "_"
    end
    display_arr
  end

  def display

    checker.indexes.each do |idx|
      p guesser.guess
      display_arr[idx] = guesser.guess
    end
    puts "\n"
    puts "Secret word: #{display_arr.join(" ")}"
    puts "Guessed Letters: #{guesser.guessed_letters.join(', ')}" if !guesser.guessed_letters.empty?
    puts "Turn: #{@turns}"
  end

  def play
    @turns = 0
      checker.pick_secret_word
      initial_display
      display

    until won?
      #p checker.word
      checker.handle_response(guesser.guess_letter)
      @turns += 1
      display
    end

    puts "It took you #{@turns} turns"

  end

  def won?
    if display_arr.all? {|x| ('a'..'z').include?(x)}
      puts "You win!"
      true
    end
  end

end


class Human
  attr_reader :guess, :word_length, :indexes, :guessed_letters
  def initialize
    @guessed_letters = []
    @word = 0
    @indexes = []
  end

  def pick_secret_word
    @word_length = nil
    loop do
      puts "How many letters is your word"
      @word_length = gets.chomp.to_i
      break if @word_length > 0
      puts "Invalid Response"
    end
    @word_length
  end

  def guess_letter
    @guess = nil
    loop do
      alphabet = ('a'..'z').to_a
      puts "Guess a letter"
      @guess = gets.chomp.downcase
      break if !@guessed_letters.include?(guess) && alphabet.include?(guess)
      puts "You already guessed that or that's not a letter!"
    end
    @guessed_letters << @guess
    @guess
  end

  def handle_response(guess)
    puts "Is #{guess} in your word?"
    @indexes = []
    loop do
      response = gets.chomp.downcase
      case response
        when "yes"
          puts "Return the spots where your word shows up e.g. 1,4"
            @indexes = gets.chomp.split(",")
            @indexes = @indexes.map {|x| x.to_i - 1 }
            return @indexes
        when "no"
          break
        else
          puts "That's not a valid answer!"
        end
    end
      p @indexes
  end




end

class Computer

  attr_accessor :word, :guess, :word_length, :indexes, :answer

  def initialize
    @word = pick_secret_word
    @guessed_letters = []
    @indexes = []
    @answer = []
  end

  def word_length
    @word_length = word.length
  end

  def pick_secret_word
    word = File.readlines("dictionary.txt").sample.chomp
  end

  def guess_letter
    @guess = nil
    alphabet = ('a'..'z').to_a
    loop do
      @guess = alphabet.sample
      break if !@guessed_letters.include?(guess)
    end
    @guessed_letters << guess
    @guess
  end

  def handle_response(guess)
    @indexes = []
    word.split("").each_with_index do |letter, idx|
      if letter == guess
        @indexes << idx
        answer << idx
      end
    end
    @indexes
  end
end

a = Human.new
c = Human.new
b = Computer.new

game = Game.new(a,b )
game.play
