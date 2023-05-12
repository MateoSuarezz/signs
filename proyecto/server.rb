require 'sinatra/base'
require 'bundler/setup'
require 'logger'
require 'sinatra/activerecord'

require 'sinatra/reloader' if Sinatra::Base.environment == :development


require_relative 'models/user'
require_relative 'models/card'


class App < Sinatra::Application
  def initialize(app = nil)
    super()
  end

  set :root,  File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, 'views') }
  

  configure :production, :development do
    enable :logging

    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
  end


  configure :development do
    register Sinatra::Reloader
    after_reload do
      puts 'Reloaded...'
    end
  end

  get '/game' do
    logger.info 'USANDO LOGGER INFO EN GAME PATH'
    'Game'
  end



  get '/' do
    erb :index
  end
  
  get '/bd' do 
  	card = Card.new 
  	card = Card.create(card_id: "1", description: "una carta", content_link: " ")
  	card.save 
  	puts card
  end 
end

