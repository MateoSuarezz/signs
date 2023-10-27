# frozen_string_literal: true

class Response < ActiveRecord::Base
  belongs_to :user, foreign_key: 'users_id'
  belongs_to :question
end
