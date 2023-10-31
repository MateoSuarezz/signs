# frozen_string_literal: true

# add_questions.rb

# Require necessary dependencies and establish a database connection
require 'active_record'
require_relative './models/modules' # Assuming your Question model is defined in this file

# Configure the database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/duo_development.sqlite3' # Replace with the actual path to your database file
)

# Define a method to add questions to the table
def add_names
  names_data = [
    { name: 'ABECEDARIO', points: 0 },
    { name: 'SALUDOS', points: 0 },
    { name: 'FAMILIA Y AMIGOS', points: 0 }
    # Add more question data as needed
  ]

  names_data.each do |data|
    name = Modules.find_or_initialize_by(name: data[:name])
    name.assign_attributes(data) # Solo asigna el atributo "name"
    name.save
  end

  puts 'Modules added successfully!'
end

# Call the method to add questions
add_names
