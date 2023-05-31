# add_cards.rb

# Require necessary dependencies and establish a database connection
require 'active_record'
require_relative './models/cards' # Assuming your Question model is defined in this file

# Configure the database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/duo_development.sqlite3' # Replace with the actual path to your database file
)

# Define a method to add questions to the table
def add_cards
  cards_data = [
    { description: 'Es una A', content_link: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Sign_language_A.svg/780px-Sign_language_A.svg.png' },
    { description: 'Es una B', content_link: 'Link 2' },
    { description: 'Es una C', content_link: 'Link 3' }
    # Add more question data as needed
  ]

  cards_data.each do |data|
    card = Card.find_or_initialize_by(card: data[:card])
    card.assign_attributes(data)
    card.save
  end

  puts 'Cards added successfully!'
end



# Call the method to add questions
add_questions
