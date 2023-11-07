# frozen_string_literal: true

# users model
class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  has_many  :responses, foreign_key: 'users_id'

  after_create :log_new_user

  private

  def log_new_user
    puts 'A new user was registered'
  end
end
