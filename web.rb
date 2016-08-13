require 'sinatra'
require 'sinatra/reloader' if development?
require './hangman'

hangman = Hangman.new
gameover = false

get '/' do
  p hangman.answer
  if gameover
    hangman = Hangman.new
    gameover = false
  end

  guess = params[:guess]
  hangman.try_to_guess(guess) if hangman.valid_guess?(guess)

  if !hangman.guess.include?('_')
    gameover = true
    erb :gameover, :locals => { :answer => hangman.answer,
                                :image_number => 6 - hangman.guesses_left,
                                :gameover_message => "你贏了！" }
  elsif hangman.guesses_left <= 0
    gameover = true
    erb :gameover, :locals => { :answer => hangman.answer,
                                :image_number => 6 - hangman.guesses_left,
                                :gameover_message => "你輸了！" }
  else
    erb :index, :locals => { :word => hangman.word,
                             :image_number => 6 - hangman.guesses_left,
                             :guessed_characters => hangman.guessed_characters }
  end
end