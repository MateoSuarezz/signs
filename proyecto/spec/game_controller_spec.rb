# frozen_string_literal: true

require 'rack/test'
require 'factory_bot'
require "#{File.dirname(__FILE__)}/factories.rb"
require "#{File.dirname(__FILE__)}/../server.rb"

RSpec.describe 'Game controller' do
  include Rack::Test::Methods

  def app
    App
  end

    describe 'GET /game/module/:n/exam/:id' do
        context 'when the user is logged in' do
            before do
                @user = FactoryBot.create(:user)
                post '/login', { email: @user.email, password: @user.password }
            end 
            modules = Modules.all.pluck(:id)
            modules.each do |module_id|
                questions = Question.where(module_id: module_id).pluck(:id)
                questions.each do |question_id|
                    it "should render the exam template for #{module_id}:#{question_id}" do
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
            it 'should redirect to the login page' do
                get '/game/module/1/exam/1'
                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.url).to include('/login')
            end
        end
    end 
    describe 'GET /learn/:n/:id' do
        context 'when the user is logged in' do
            before do
                @user = FactoryBot.create(:user)
                post '/login', { email: @user.email, password: @user.password }
            end 
            modules = Modules.all.pluck(:id)
            modules.each do |module_id|
                questions = Question.where(module_id: module_id).pluck(:id)
                questions.each do |question_id|
                    it "should render the learn template for #{module_id}:#{question_id}" do
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
            it 'should redirect to the login page' do
                get '/learn/1/1'
                expect(last_response).to be_redirect
                follow_redirect!
                expect(last_request.url).to include('/login')
            end
        end
    end

    describe 'POST /exam/check-answer/:n/:id' do
        before do
            @user = FactoryBot.create(:user)
            post '/login', { email: @user.email, password: @user.password }
            get '/game/module/1/exam/1'
        end

        it 'should update response for a correct answer' do
  
          post "/exam/check-answer/1/1", :answer => 'true'
    
          response = Response.find_by(users_id: @user.id, questions_id: 1)
          expect(response.correct_answer).to eq(true)
        end
    
        it 'should not update response for an incorrect answer' do
          post "/exam/check-answer/1/1", :answer => 'false'    
          response = Response.find_by(users_id: @user.id, questions_id: 1)
          expect(response.correct_answer).to eq(false)
        end
    
        it 'should redirect to the next question if not the last question' do
            post "/exam/check-answer/1/1", :answer => 'true'
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path_info).to eq("/game/module/1/exam/2")
        end
    
        it 'should redirect to /game if the last question of the module' do
            post "/exam/check-answer/1/5", :answer => 'true'
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path_info).to eq('/game')
        end
        after do
            @user.responses.destroy_all
            @user.destroy
        end
      end

    describe 'post /learn/:n/:id' do
        before do
            @user = FactoryBot.create(:user)
            post '/login', { email: @user.email, password: @user.password }
        end
        it 'should redirect to /game if the last question of the module' do
            post "/learn/1/5"
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path_info).to eq('/game')
        end
        it 'should redirect to the next question if not the last question' do
            post "/learn/1/1"
            expect(last_response).to be_redirect
            follow_redirect!
            expect(last_request.path_info).to eq("/learn/1/2")
        end
        after do
            @user.responses.destroy_all
            @user.destroy
        end
    end
end 