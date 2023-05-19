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
require 'sinatra/reloader' if Sinatra::Base.environment == :development

# App, currently: Is connected to the database.
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
    get '/' do
      erb :index
    end
    
    post '/user' do
      @user = User.find_or_create_by(email: params[:email])
      @user.password = params[:password]
      if @user.save
        redirect '/game'
      else
        "Error saving user: #{@user.errors.full_messages.join(', ')}"
      end
    end
    
    post '/login' do
      @user = User.find_by(email: params[:email])
      if @user && @user.authenticate(params[:password])
        redirect '/game'
      else
        redirect '/login'
      end
    end
    

    get '/login'do
      erb :login
    end 

    get '/game' do
      erb :game
    end
    
    get '/' do
      erb :index
    end

    get '/game/module1/exam/:id' do
      @user = User.first
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
      question = Question.find_by(id: question_id)
      @preguntas = Question.all
      logger.info "Testing: #{@preguntas.length}"

      if question && question.answer == to_boolean(user_answer)
        @user = User.find_by(id:params[:user_id])
        @user.points =( @user.points || 0 ) + 10
        @user.save
      end

      next_id = question_id.to_i + 1

      if (next_id > @preguntas.length) 
        redirect "/game"
      end

      session[:current_index] = next_id
      redirect "/game/module1/exam/#{next_id}"
    end
    
    get '/ver_preguntas' do 
    	load 'add_questions.rb'
    	Question.all.to_json
    end 
end
