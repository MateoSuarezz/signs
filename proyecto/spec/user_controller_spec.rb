# frozen_string_literal: true

require 'rack/test'
require 'factory_bot'
require "#{File.dirname(__FILE__)}/factories.rb"
require "#{File.dirname(__FILE__)}/../server.rb"

RSpec.describe 'User controller' do
  include Rack::Test::Methods

  def app
    App
  end

  describe 'POST /user' do
    context 'when creating a new user' do
      before(:each) do
        @user = FactoryBot.build(:user)
        post '/user', { email: @user.email, name: @user.name, password: @user.password }
      end

      it 'should create a new user' do
        user_from_db = User.find_by(email: @user.email)
        expect(user_from_db).not_to be_nil
      end
      it 'should redirect to game page' do
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to include('/game')
      end
      after(:each) do
        user = User.find_by(email: @user.email)
        user.responses.destroy_all
        user.destroy
      end
    end
    context 'when creating a new user with an existing email' do
      before(:each) do
        @user = FactoryBot.create(:user)
        post '/user', { email: @user.email, name: @user.name, password: @user.password }
      end

      it 'should not create a new user' do
        user_from_db = User.find_by(email: @user.email)
        expect(user_from_db).not_to be_nil
      end
      it 'should show an error message' do
        expect(last_response.body).to include('El usuario o el correo electrónico ya existe.')
      end
      after(:each) do
        user = User.find_by(email: @user.email)
        user.responses.destroy_all
        user.destroy
      end
    end
  end
  describe 'POST /login' do
    context 'when logging in with an existing user' do
      before(:each) do
        @user = FactoryBot.create(:user)
        post '/login', { email: @user.email, password: @user.password }
      end

      it 'should redirect to game page' do
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to include('/game')
      end
      after(:each) do
        user = User.find_by(email: @user.email)
        user.responses.destroy_all
        user.destroy
      end
    end
    context 'when logging in with a non-existing user' do
      before(:each) do
        @user = FactoryBot.build(:user)
        post '/login', { email: @user.email, password: @user.password }
      end

      it 'should show an error message' do
        expect(last_response.body).to include('correo o contraseña incorrectos')
      end
    end
  end
end
