# add_questions.rb

# Require necessary dependencies and establish a database connection
require 'active_record'
require_relative 'db/models/question' # Assuming your Question model is defined in this file

# Configure the database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/duo_development.sqlite3' # Replace with the actual path to your database file
)

# Define a method to add questions to the table
def add_questions
  questions_data = [
    { question: 'Esta es la letra A?', answer: true, content_link: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Sign_language_A.svg/780px-Sign_language_A.svg.png' },
    { question: 'Question 2', answer: false, content_link: 'Link 2' },
    { question: 'Question 3', answer: true, content_link: 'Link 3' }
    # Add more question data as needed
  ]

  questions_data.each do |data|
    question = Question.find_or_initialize_by(question: data[:question])
    question.assign_attributes(data)
    question.save
  end

  puts 'Questions added successfully!'
end

def get_all_questions
  Question.all
end


# Call the method to add questions
add_questions
