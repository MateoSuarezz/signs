# frozen_string_literal: true

require 'sinatra/base'
require 'bundler/setup'
require 'logger'
require 'sinatra/activerecord'
require 'active_record'
require 'yaml'
Dir['./models/*.rb'].sort.each { |file| require file }
require_relative 'db/info_loaders/add_game_info'
require 'simplecov'
require 'sinatra/reloader' if Sinatra::Base.environment == :development

# Initialize the application
class App < Sinatra::Application
  configure do
    # Database configuration
    db_config = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(db_config['development'])

    # General configuration
    set :root, File.dirname(__FILE__)
    set :views, File.join(root, 'views')
    set :public_folder, "#{File.dirname(__FILE__)}/public"

    enable :sessions
    enable :logging

    configure :development do
      register Sinatra::Reloader
      enable :dump_errors, :raise_errors
      set :logger, Logger.new($stdout, level: Logger::DEBUG)
    end
  end

  register Sinatra::ActiveRecordExtension

  before do
    pass if request.path_info == '/login' || request.path_info == '/signup'
    redirect '/signup' unless user_logged_in?
  end

  # Helpers
  helpers do
    def user_logged_in?
      session[:user_id]
    end

    def load_points
      @user = User.find_by(id: session[:user_id])
      @modules = Module.all
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
  end

  # Routes
  post '/user' do
      existing_user = User.find_by(email: params[:email])
      existing_name = User.find_by(name: params[:name])
    
      if existing_user || existing_name
        redirect '/'
      else
        @user = User.create(name: params[:name], email: params[:email], password: params[:password])
        session[:user_id] = @user.id
        redirect '/game'
      end
  end

  post '/login' do
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/game'
    else
      redirect '/login'
    end
  end

  get '/game' do
    if user_logged_in?
      load_points
      erb :game
    else
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
    redirect user_logged_in? ? '/game' : '/signup'
  end

  get '/signup' do
    if user_logged_in?
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
    # Display user ranking
    @users = User
             .joins(:responses)
             .where(responses: { correct_answer: true })
             .group('users.id')
             .order(Arel.sql('COUNT(responses.id) DESC'))
             .select('users.*, COUNT(responses.id) AS correct_responses_count')
    erb :ranking
  end
end
