# frozen_string_literal: true

require 'rack/test'
require 'factory_bot'
require "#{File.dirname(__FILE__)}/factories.rb"
require "#{File.dirname(__FILE__)}/../server.rb"

RSpec.describe 'Sinatra App' do
  include Rack::Test::Methods

  def app
    App
  end

  context 'when no user is logged in' do
    routes_to_test = [
      '/login',
      '/signup',
      '/ranking'
    ]

    routes_to_test.each do |route|
      it "returns a 200 status for #{route}" do
        get route
        expect(last_response.status).to eq(200) # Verify the HTTP response status code
      end
    end

    it 'redirects to the login page when accessing /game' do
      get '/game'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include('/login')
    end

    it 'redirects to the signup page when accessing /' do
      get '/'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include('/signup')
    end

    it 'redirects to the login page when logging out' do
      get '/logout'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include('/login')
    end
  end

  context 'when a user is logged in' do
    before(:each) do
      @user = FactoryBot.create(:user)
      post '/login', { email: @user.email, password: @user.password }
    end

    it 'accesses /game when a user is logged in' do
      get '/game'
      expect(last_response.status).to eq(200) # Verifica que se cargue la página
    end

    it 'redirects to /game when accessing /' do
      get '/'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include('/game')
    end

    it 'redirects to /game when accessing /login' do
      get '/login'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include('/game')
    end

    it 'redirects to /game when accessing /signup' do
      get '/signup'
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
end
