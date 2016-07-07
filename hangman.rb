class Hangman
  attr_reader :answer, :guesses_left
  def initialize
    @answer = random_word
    @guesses_left = 6
    @guess = Array.new(@answer.length, '_')
  end

  def display
    @guess.join(' ')
  end

  def try_to_guess(input)
    guess(input) if valid_guess?(input)
  end

  private

  def random_word
    File.open('dictionary.txt', 'r') do |file|
      file.readlines.select{ |word| word.length.between?(6, 13) }.sample.chomp.split('')
    end
  end

  def valid_guess?(input)
    input.length == 1 && /[A-Za-z]/ === input
  end

  def guess(input)
    guess_right = false
    @answer.each_with_index do |word, i|
      if word.downcase == input
        guess_right = true
        @guess[i] = word
      end
    end
    @guesses_left -= 1 unless guess_right
  end
end

hangman = Hangman.new
p hangman.answer
p hangman.display
p hangman.guesses_left
