require 'sinatra'
require 'sinatra/reloader' if development?
require './hangman'

hangman = Hangman.new

get '/' do
  guess = params[:guess]
  hangman.guess(guess) if hangman.valid_guess?(guess)
  word = hangman.word
  erb :index, :locals => { :word => word }
end