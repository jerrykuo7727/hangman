class Hangman
  attr_reader :answer
  def initialize
    @answer = random_word
    @guesses_left = 6
    @guess = Array.new(@answer.length, '_')
  end

  def display
    @guess.join(' ')
  end

  private

  def random_word
    File.open('dictionary.txt', 'r') do |file|
      file.readlines.select{ |word| word.length.between?(6, 13) }.sample.chomp
    end
  end
end

hangman = Hangman.new
p hangman.answer
p hangman.display