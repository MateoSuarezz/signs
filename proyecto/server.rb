# frozen_string_literal: true

require 'sinatra/base'
require 'bundler/setup'
require 'logger'
require 'sinatra/activerecord'
require 'active_record'
require 'yaml'
Dir['./models/*.rb'].sort.each { |file| require file }
require_relative 'add_questions'
require_relative 'add_modules'
require_relative 'add_cards'
require 'simplecov'
require 'sinatra/reloader' if Sinatra::Base.environment == :development

# App, currently: Is connected to the database.
class App < Sinatra::Application
  # Config about the database and the sets for the .erb
  configure do
    db_config = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(db_config['development'])

    set :root, File.dirname(__FILE__)
    set :views, File.join(root, 'views')
    set :public_folder, "#{File.dirname(__FILE__)}/public"

    configure :development do
      register Sinatra::Reloader
      enable :logging, :dump_errors, :raise_errors
    end
  end
  # Config sessions
  configure do
    enable :sessions
  end
  # Config fot the inizialitation of the app

  def initialize(_app = nil)
    super()
  end
  register Sinatra::ActiveRecordExtension
  set :root,  File.dirname(__FILE__)
  set :views, proc { File.join(root, 'views') }

  configure :production, :development do
    enable :logging

    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
  end

  configure :development do
    register Sinatra::Reloader
    after_reload do
      puts 'Reloaded...'
    end
  end

  # Config of all the posts and the gets
  post '/user' do
    existing_user = User.find_by(email: params[:email])
    existing_name = User.find_by(name: params[:name])
    if existing_user || existing_name
      'El usuario o el correo electrónico ya existe.'
    else
      @user = User.create(name: params[:name],
                          email: params[:email],
                          password: params[:password])

      session[:user_id] = @user.id
      redirect '/game'
    end
  end

  def user_logged_in?
    session[:user_id] != nil
  end

  def load_points
    @user = User.find_by(id: session[:user_id])
    @modules = Modules.all
    @points = []
    @modules.each do |mod|
      questions = Question.where(module_id: mod.id)
      p = 0
      questions.each do |q|
        r = Response.find_or_create_by(users_id: session[:user_id], questions_id: q.id)
        p += 10 if r.correct_answer
      end
      @points.push(p)
    end
  end

  def reset_responses(module_id)
    questions = Question.where(module_id: module_id)
    questions.each do |q|
      r = Response.find_or_create_by(users_id: session[:user_id], questions_id: q.id)
      r.update(correct_answer: false)
    end
  end

  post '/login' do
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/game'
    else
      'correo o contraseña incorrectos'
    end
  end

  get '/game' do
    # Check if the user is authenticated
    if user_logged_in?
      load_points
      erb :game
    else
      # User is not authenticated, redirect to login or show an error
      redirect '/login'
    end
  end

  get '/login' do
    if user_logged_in?
      redirect '/game'
    else
      erb :login
    end
  end

  get '/' do
    if session[:user_id]
      redirect '/game'
    else
      redirect '/signup'
    end
  end

  get '/signup' do
    if session[:user_id]
      redirect '/game'
    else
      erb :index
    end
  end

  get '/game/module/:n/exam/:id' do
    if user_logged_in?
      @module = params[:n].to_i
      @pregunta = Question.find(params[:id].to_i)
      @correct_answer = @pregunta.answer.to_s

      reset_responses(@module) if [1, 6, 11].include? @pregunta.id
      erb :exam
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/login'
  end

  # Ruta para procesar las respuestas
  post '/exam/check-answer/:n/:id' do
    @module = params[:n].to_i
    question_id = params[:id].to_i
    user_answer = params[:answer] == 'true'
    question = Question.find(question_id)
    @preguntas = Question.where(module_id: @module)

    if question.answer == user_answer
      response = Response.find_by(users_id: session[:user_id], questions_id: question_id)
      response.update(correct_answer: true)
    end

    next_id = question_id + 1
    if next_id > @module * 5
      redirect '/game'
    else
      redirect "/game/module/#{@module}/exam/#{next_id}"
    end
  end

  get '/learn/:n/:id' do
    if user_logged_in?
      @module = params[:n].to_i
      @carta = Card.find(params[:id].to_i)
      erb :learn
    else
      redirect '/login'
    end
  end

  post '/learn/:n/:id' do
    card_id = params[:id].to_i
    module_id = params[:n].to_i
    cards = Card.where(module_id: module_id)
    if card_id + 1 > cards.length * module_id
      redirect '/game'
    else
      redirect "/learn/#{module_id}/#{card_id + 1}"
    end
  end

  get '/ranking' do
    @users = User
             .joins(:responses)
             .where(responses: { correct_answer: true })
             .group('users.id')
             .order(Arel.sql('COUNT(responses.id) DESC'))
             .select('users.*, COUNT(responses.id) AS correct_responses_count')
    erb :ranking
  end
end
