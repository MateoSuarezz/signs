require_relative 'helpers/user_helper'
require_relative 'helpers/game_helper'
Dir['../models/*.rb'].sort.each { |file| require file }

class UserController < Sinatra::Base
    helpers UserHelper, GameHelper

    post '/user' do
        existing_user = User.find_by(email: params[:email])
        existing_name = User.find_by(name: params[:name])

        if existing_user || existing_name
        '/'
        else
        @user = User.create(
            name: params[:name],
            email: params[:email],
            password: params[:password]
        )

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
      '/login'
    end
  end

  get '/game' do
    if user_logged_in
      load_points
      erb :game
    else
      redirect '/login'
    end
  end

  get '/login' do
    if user_logged_in
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

  get '/logout' do
    session[:user_id] = nil
    redirect '/login'
  end
end