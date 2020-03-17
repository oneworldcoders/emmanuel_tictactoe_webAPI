require 'sinatra'
require "sinatra/reloader"
require "tic_tac_toe"



get '/' do
    # @tictactie = TicTacToe::Tic_tac_toe.new
    "created"
end

get '/play' do
    # @tictactoe.welcome
end

