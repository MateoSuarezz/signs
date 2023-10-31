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
    { question: 'Esta seña representa mamá', answer: true, content_link: '/images/mama.png', module_id: 2 },
    { question: 'Basta de bromas, esto es serio. Asi se dice abuelo/a', answer: true, content_link: '/images/abuelos.png', module_id: 2 },
    { question: 'Esta seña representa abuelo', answer: true, content_link: '/images/abuelo.png', module_id: 2 },
    { question: 'Lo que describe esta seña es hermanos', answer: false, content_link: '/images/hijos.png', module_id: 2 },
    { question: 'Esta seña corresponde a tio', answer: false, content_link: '/images/papa.png', module_id: 2 }
  ]

  questions_data.each do |data|
    data[:answer] = false if data[:answer].nil?  # Set answer to false if not specified
    q = Question.find_or_initialize_by(question: data[:question], content_link: data[:content_link], module_id: data[:module_id])
    q.assign_attributes(data)
    q.answer = data[:answer]  # Set the answer attribute explicitly
    q.save
  end
  

  puts 'Questions added successfully!'
end



# Call the method to add questions
add_questions
