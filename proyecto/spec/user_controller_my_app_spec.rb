# frozen_string_literal: true

require 'rack/test'
require 'factory_bot'
require "#{File.dirname(__FILE__)}/factories.rb"
RSpec.describe MyApp do
  # Test for user controller
  include Rack::Test::Methods

  def app
    MyApp
  end

  describe 'POST /user' do
    context 'when creating a new user' do
      before do
        @user = build(:user)
        post '/user', { email: @user.email, name: @user.name, password: @user.password }
      end

      after do
        user = User.find_by(email: @user.email)
        user.responses.destroy_all
        user.destroy
      end

      it 'creates a new user' do
        user_from_db = User.find_by(email: @user.email)
        expect(user_from_db).not_to be_nil
      end

      it 'redirects to game page' do
        follow_redirect!
        expect(last_request.url).to include('/game')
      end
    end

    context 'when creating a new user with an existing email' do
      before do
        @user = create(:user)
        post '/user', { email: @user.email, name: @user.name, password: @user.password }
      end

      after do
        user = User.find_by(email: @user.email)
        user.responses.destroy_all
        user.destroy
      end

      it 'does not create a new user' do
        user_from_db = User.find_by(email: @user.email)
        expect(user_from_db).not_to be_nil
      end

      it 'shows an error message' do
        expect(last_response.body).to include('El usuario o el correo electrónico ya existe.')
      end
    end
  end

  describe 'POST /login' do
    context 'when logging in with an existing user' do
      before do
        @user = create(:user)
        post '/login', { email: @user.email, password: @user.password }
      end

      after do
        user = User.find_by(email: @user.email)
        user.responses.destroy_all
        user.destroy
      end

      it 'redirects to /game' do
        follow_redirect!
        expect(last_request.url).to include('/game')
      end
    end

    context 'when logging in with a non-existing user' do
      before do
        @user = build(:user)
        post '/login', { email: @user.email, password: @user.password }
      end

      it 'shows an error message' do
        expect(last_response.body).to include('correo o contraseña incorrectos')
      end
    end
  end
end
