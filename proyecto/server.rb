require 'sinatra/base'
require 'bundler/setup'
require 'logger'
require 'sinatra/activerecord'
require 'active_record'
require 'yaml'
require_relative './models/user'
require_relative './models/card'
require_relative './models/question'
require_relative 'add_questions'
require_relative 'add_modules'
require 'simplecov' 
require_relative 'add_cards'
require 'sinatra/reloader' if Sinatra::Base.environment == :development


#App, currently: Is connected to the database.
class App < Sinatra::Application
  
#Config about the database and the sets for the .erb
  configure do
    db_config = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(db_config['development'])

    set :root, File.dirname(__FILE__)
    set :views, File.join(root, 'views')

    configure :development do
      register Sinatra::Reloader
      enable :logging, :dump_errors, :raise_errors
    end
  end
#Config sessions
  configure do
    enable :sessions
  end
#Config fot the inizialitation of the app 
    
  def initialize(app = nil)
      super()
    end
    register Sinatra::ActiveRecordExtension
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

#Config of all the posts and the gets
    post '/user' do
      existing_user = User.find_by(email: params[:email])
      if existing_user
        "El usuario con el correo electrónico #{params[:email]} ya existe."
      else
        @user = User.find_or_create_by(email: params[:email])
        @user.password = params[:password]
        if @user.save 
          session[:user_id] = @user.id
          redirect '/game'
        else
          "Error saving user: #{@user.errors.full_messages.join(', ')}"
        end
      end
    end
    
    
    post '/login' do
      @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/game'
      else
        redirect '/login'
      end
    end    

    get '/game' do
      # Check if the user is authenticated
      if session[:user_id]
        @module = Modules.all
        erb :game
      else
        # User is not authenticated, redirect to login or show an error
        redirect '/login'
      end
    end

    get '/login' do
      if session[:user_id]
        redirect '/game'
      else
        erb :login
      end
    end

    get '/' do
      if session[:user_id]
        redirect '/game'
      else
        erb :index
      end
    end

    get ' ' do
      if session[:user_id]
        redirect '/game'
      else
        erb :index
      end
    end

    

    get '/game/module1/exam/:id' do
      @user = User.first
      @module = Modules.first
      @preguntas = Question.all
      @current_index = session[:current_index] || 0
      @pregunta = @preguntas[params[:id].to_i - 1]
      erb :exam

    end
    
    def to_boolean(str)
      str == 'true'
    end

    # Ruta para procesar las respuestas
    post '/game/module1/exam/:id' do
      question_id = params[:id]
      user_answer = params[:answer]
      button_next = params[:next]
      question = Question.find_by(id: question_id)
      @preguntas = Question.all

      @module = Modules.find_by(id: 1)
      

      if (@module.points != 0 && question_id.to_i == 1)
        @module.points = 0
        @module.save
      end

      if question && question.answer == to_boolean(user_answer)
        @module.points =( @module.points ) + 10
        @module.save
      end

        next_id = question_id.to_i + 1
        if (next_id > @preguntas.length)
          redirect "/game"
        else
          redirect "/game/module1/exam/#{next_id}"
        end
    end
    get '/ver_preguntas' do 
    	load 'add_questions.rb'
    	Question.all.to_json
    end 
    get '/ver_modulos' do 
    	load 'add_modules.rb'
    	Modules.all.to_json
    end 

    get '/game/module1/learn/:id' do
      @module = Modules.first
      @cards = Card.all
      @current_index = session[:current_index] || 0
      @carta = @cards[params[:id].to_i-1]
      erb :learn
    end

    post '/game/module1/learn/:id' do
      card_id = params[:id]
      button_next = params[:next]
      content = Card.find_by(id: card_id)
      @cards = Card.all
    
      next_id = card_id.to_i + 1
        if (next_id > @cards.length)
          redirect "/game"
        else
          redirect "/game/module1/learn/#{next_id}"
        end

    end
  end