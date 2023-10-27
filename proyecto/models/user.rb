# frozen_string_literal: true

class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  has_many  :responses, foreign_key: 'users_id'
end
