# add_questions.rb

# Require necessary dependencies and establish a database connection
require 'active_record'
require_relative './models/question' # Assuming your Question model is defined in this file

# Configure the database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/duo_development.sqlite3' # Replace with the actual path to your database file
)

# Define a method to add questions to the table
def add_questions
  questions_data = [
    { question: '¿Esta seña corresponde a la letra A?', answer: true, content_link: '/images/letraA.png', module_id: 1 },
    { question: 'La letra "CH" fue sacada del alfabeto convencional, por ende, no tiene seña correspondiente', answer: false, content_link: '/images/letraCH.png', module_id: 1 },
    { question: 'Esta seña es la letra I', answer: true, content_link: '/images/letraI.png', module_id: 1 },
    { question: 'La letra "V" solo tiene una variante y es la que se ve en pantalla', answer: false, content_link: '/images/letraU.png', module_id: 1 },
    { question: 'Esta seña corresponde a la letra E', answer: false, content_link: '/images/letraE.png', module_id: 1 },
  ]

  questions_data.each do |data|
    question = Question.find_or_initialize_by(question: data[:question])
    question.assign_attributes(data)
    question.save
  end

  puts 'Questions added successfully!'
end



# Call the method to add questions
add_questions
