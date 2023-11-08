require_relative 'helpers/game_helper'
require_relative 'helpers/user_helper'
Dir['../models/*.rb'].sort.each { |file| require file }

class GameController < Sinatra::Base
  helpers GameHelper, UserHelper
    post '/exam/check-answer/:n/:id' do
        @module = params[:n].to_i
        question_id = params[:id].to_i
        user_answer = params[:answer] == 'true'
        question = Question.find(question_id)
        @preguntas = Question.where( module_id: @module)
    
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
        if user_logged_in
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

      get '/game/module/:n/exam/:id' do
        if user_logged_in
          @module = params[:n].to_i
          @pregunta = Question.find(params[:id].to_i)
          @correct_answer = @pregunta.answer.to_s
    
          reset_responses(@module) if [1, 6, 11].include? @pregunta.id
          erb :exam
        else
          redirect '/login'
        end
      end

  end