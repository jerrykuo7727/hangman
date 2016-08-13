require 'sinatra'
require 'sinatra/reloader' if development?
require './hangman'

get '/' do
  erb :index
end