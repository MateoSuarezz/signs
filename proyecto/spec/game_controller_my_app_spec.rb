# frozen_string_literal: true

require 'rack/test'
require 'factory_bot'
require "#{File.dirname(__FILE__)}/factories.rb"

RSpec.describe MyApp do
  include Rack::Test::Methods

  def app
    MyApp
  end

  describe 'GET /game/module/:n/exam/:id' do
    context 'when the user is logged in' do
      before do
        @user = create(:user)
        post '/login', { email: @user.email, password: @user.password }
      end

      modules = Modules.all.pluck(:id)
      modules.each do |module_id|
        questions = Question.where(module_id: module_id).pluck(:id)
        questions.each do |question_id|
          it "renders the exam template for #{module_id}:#{question_id}" do
            get "/game/module/#{module_id}/exam/#{question_id}"
            expect(last_response.status).to eq(200)
          end
        end
      end
      after do
        @user.responses.destroy_all
        @user.destroy
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the login page' do
        get '/game/module/1/exam/1'
        follow_redirect!
        expect(last_request.url).to include('/login')
      end
    end
  end

  describe 'GET /learn/:n/:id' do
    context 'when the user is logged in' do
      before do
        @user = create(:user)
        post '/login', { email: @user.email, password: @user.password }
      end

      modules = Modules.all.pluck(:id)
      modules.each do |module_id|
        questions = Question.where(module_id: module_id).pluck(:id)
        questions.each do |question_id|
          it "renders the learn template for #{module_id}:#{question_id}" do
            get "/learn/#{module_id}/#{question_id}"
            expect(last_response.status).to eq(200)
          end
        end
      end
      after do
        @user.responses.destroy_all
        @user.destroy
      end
    end

    context 'when the user is not logged in' do
      it 'redirects to the login page' do
        get '/learn/1/1'
        follow_redirect!
        expect(last_request.url).to include('/login')
      end
    end
  end

  describe 'POST /exam/check-answer/:n/:id' do
    before do
      @user = create(:user)
      post '/login', { email: @user.email, password: @user.password }
      get '/game/module/1/exam/1'
    end

    after do
      @user.responses.destroy_all
      @user.destroy
    end

    it 'updates response for a correct answer' do
      post '/exam/check-answer/1/1', answer: 'true'

      response = Response.find_by(users_id: @user.id, questions_id: 1)
      expect(response.correct_answer).to be(true)
    end

    it 'does not update response for an incorrect answer' do
      post '/exam/check-answer/1/1', answer: 'false'
      response = Response.find_by(users_id: @user.id, questions_id: 1)
      expect(response.correct_answer).to be(false)
    end

    it 'redirects to the next question if not the last question' do
      post '/exam/check-answer/1/1', answer: 'true'
      follow_redirect!
      expect(last_request.path_info).to eq('/game/module/1/exam/2')
    end

    it 'redirects to /game if the last question of the module' do
      post '/exam/check-answer/1/5', answer: 'true'
      follow_redirect!
      expect(last_request.path_info).to eq('/game')
    end
  end

  describe 'post /learn/:n/:id' do
    before do
      @user = create(:user)
      post '/login', { email: @user.email, password: @user.password }
    end

    after do
      @user.responses.destroy_all
      @user.destroy
    end

    it 'redirects to /game if the last question of the module' do
      post '/learn/1/5'
      follow_redirect!
      expect(last_request.path_info).to eq('/game')
    end

    it 'redirects to the next question if not the last question' do
      post '/learn/1/1'
      follow_redirect!
      expect(last_request.path_info).to eq('/learn/1/2')
    end
  end
end
