class Hangman
  attr_reader :answer
  def initialize
    @answer = random_word
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