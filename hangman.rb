require 'yaml'

class Hangman
  attr_reader :answer, :guesses_left
  def initialize
    @answer = random_word
    @guesses_left = 6
    @guess = Array.new(@answer.length, '_')
    @guessed_characters = []
  end

  def start
    until gameover?
      ask_to_guess
    end
    input = nil
    until %w(y n).include?(input) do
      print "Start another game?[Y/N]"
      input = gets.chomp.downcase
    end
    return input
  end

  private

  def random_word
    File.open('dictionary.txt', 'r') do |file|
      file.readlines.select{ |word| word.length.between?(6, 13) }.sample.chomp.split('')
    end
  end

  def ask_to_guess
    input = '0'
    until valid_guess?(input) do
      display
      print "Please enter a character: #{input}"
      input = gets.chomp.downcase
      case input
      when 'save'
        save
      when 'load'
        load
      when 'delete'
        delete
      else
        puts "Invalid or duplicate guess! Try again." unless valid_guess?(input)
      end
      puts
    end
    guess(input)
  end

  def save
    Dir.mkdir('savedata') unless Dir.exist?('savedata')
    data = {
      answer: @answer,
      guesses_left: @guesses_left,
      guess: @guess,
      guessed_characters: @guessed_characters
    }
    id = Dir["savedata/*.yaml"].size + 1
    savedata = YAML.dump(data)
    File.open("savedata/savedata#{id}.yaml", 'w') { |file| file.write(savedata) }
  end

  def load
    size = Dir["savedata/*.yaml"].size.to_s
    if size == '0'
      puts "No savedata found!"
    else
      id = '-1'
      until ('1'..size).include?(id)
        print "There are #{size} savedatas, which one: "
        id = gets.chomp
        puts "Invalid number! Try again." unless ('1'..size).include?(id)
      end
      savedata = File.open("savedata/savedata#{id}.yaml", 'r') { |file| file.read }
      data = YAML.load(savedata)
      @answer = data[:answer]
      @guesses_left = data[:guesses_left]
      @guess = data[:guess]
      @guessed_characters = data[:guessed_characters]
    end
  end

  def delete
    Dir["savedata/*.yaml"].each { |filepath| File.delete(filepath)}
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
    win unless @guess.include?('_')
    unless guess_right
      @guesses_left -= 1 
      @guessed_characters << input
      lose if @guesses_left <= 0
    end
  end

  def gameover?
    @guesses_left <= 0 || !@guess.include?('_')
  end

  def win
    puts "You win the game!"
    puts
  end

  def lose
    puts "You lose the game!"
    puts
  end

  def display
    puts "#{@guess.join(' ')}" << " (#{@guesses_left.to_s} guesses left)"
    puts "Past guesses: #{@guessed_characters.join(' ')}"
  end
end
=begin
puts "***********************************"
puts "* Hangman: guess the secret word! *"
puts "*   # Below is the command list   *"
puts "*     'save', 'load', 'delete'    *"
puts "***********************************"
restart = 'y'
while restart == 'y' do
  hangman = Hangman.new
  restart = hangman.start
end
puts "Thank you for playing, bye-bye!"
=end