# frozen_string_literal: true

require 'csv'
require 'active_record'
require_relative '../../models/card'
require_relative '../../models/modules'
require_relative '../../models/question'

# Configure the database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/duo_development.sqlite3'
)

def add_cards
  data = {}
  CSV.foreach('db/info_loaders/cards.csv', headers: true) do |row|
    data[:description] = row['description']
    data[:content_link] = row['content_link']
    data[:module_id] = row['module_id']
    Card.find_or_create_by(data)
  end
end

def add_questions
  data = {}
  CSV.foreach('db/info_loaders/questions.csv', headers: true) do |row|
    data[:question] = row['question']
    data[:answer] = row['answer']
    data[:content_link] = row['content_link']
    data[:module_id] = row['module_id']
    Question.find_or_create_by(data)
  end
end

def add_modules
  data = {}
  CSV.foreach('db/info_loaders/modules.csv', headers: true) do |row|
    data[:name] = row['name']
    Modules.find_or_create_by(data)
  end
end

add_cards
add_questions
add_modules
puts 'Game info loaded!'
