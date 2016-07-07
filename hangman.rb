class Hangman
  attr_reader :answer, :guesses_left
  def initialize
    @answer = random_word
    @guesses_left = 6
    @guess = Array.new(@answer.length, '_')
    @guessed_characters = []
  end

  def display
    puts "#{@guess.join(' ')}" << " (#{@guesses_left.to_s} guesses left)"
    puts "Past guesses: #{@guessed_characters.join(' ')}"
  end

  def ask_to_guess
    input = '0'
    until valid_guess?(input) do
      display
      input = random_guess.downcase
      puts "Please enter a character: #{input}"
      puts "Invalid or duplicate guess! Try again." unless valid_guess?(input)
      puts
    end
    guess(input)
  end

  private

  def random_word
    File.open('dictionary.txt', 'r') do |file|
      file.readlines.select{ |word| word.length.between?(6, 13) }.sample.chomp.split('')
    end
  end

  def valid_guess?(input)
    input.length == 1 && /[A-Za-z]/ === input \
      && !@guess.include?(input) && !@guessed_characters.include?(input)
  end

  def guess(input)
    guess_right = false
    @answer.each_with_index do |word, i|
      if word.downcase == input
        guess_right = true
        @guess[i] = word
      end
    end
    unless guess_right
      @guesses_left -= 1 
      @guessed_characters << input
    end
  end
end

def random_guess
  (('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a).sample
end

hangman = Hangman.new
p hangman.answer
hangman.ask_to_guess
hangman.ask_to_guess
hangman.ask_to_guess

