require 'sinatra'
require "tic_tac_toe"


class Review
    include TicTacToe

    def initialize()
        @ins = TicTacToe::Language.new
    end

    def welcome
        @ins.get_string('welcome_message')
    end

end

class App < Sinatra::Base

    get '/' do
        "Hello World\nThis is a new line"
    end

    get '/welcome' do
        Review.new().welcome
    end

end

