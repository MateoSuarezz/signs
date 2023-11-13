# frozen_string_literal: true

# questions model
class Question < ActiveRecord::Base
  has_one :module
  has_many :responses
  validates :answer, presence: true, allow_blank: true
  validates :question, presence: true
  validates :content_link, presence: true, format: { with: %r{\A/images/} }
  validates :module_id, presence: true
end
