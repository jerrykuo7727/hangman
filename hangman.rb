class Hangman
  attr_reader :guess, :guesses_left

  def initialize
    @answer = random_word
    @guesses_left = 6
    @guess = Array.new(@answer.length, '_')
    @guessed_characters = []
  end

  def valid_guess?(input)
    return false unless input.class == String
    input.length == 1 && /[A-Za-z]/ === input \
      && !@guess.include?(input) && !@guessed_characters.include?(input)
  end

  def try_to_guess(input)
    return nil unless input.class == String

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

  def word
    @guess.join(' ')
  end

  def answer
    @answer.join(' ')
  end

  def guessed_characters
    @guessed_characters.join(' ')
  end

  private

  def random_word
    File.open('dictionary.txt', 'r') do |file|
      file.readlines.select{ |word| word.length.between?(6, 13) }.sample.chomp.split('')
    end
  end

  def gameover?
    @guesses_left <= 0 || !@guess.include?('_')
  end
end