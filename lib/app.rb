require 'sinatra'
require "sinatra/reloader"
require "tic_tac_toe"


class App < Sinatra::Base
    get '/' do
        # @tictactie = TicTacToe::Tic_tac_toe.new
        'Welcome to tic tac toe'
    end

    get '/play' do
        # @tictactoe.welcome
    end
end

