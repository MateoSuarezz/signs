# add_cards.rb

# Require necessary dependencies and establish a database connection
require 'active_record'
require_relative './models/card' # Assuming your Question model is defined in this file

# Configure the database connection
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/duo_development.sqlite3' # Replace with the actual path to your database file
)

# Define a method to add questions to the table
def add_cards
  cards_data = [
    { description: 'Es una A', content_link: '/images/letraA.png',module_id: 1 },
    { description: 'Es una E', content_link: '/images/letraE.png',module_id: 1 },
    { description: 'Es una U', content_link: '/images/letraU.png',module_id: 1 },
    { description: 'Es una O', content_link: '/images/letraO.png',module_id: 1 },
    { description: 'Es una I', content_link: '/images/letraI.png',module_id: 1 },
    { description: 'Esta es la seña para decir mama', content_link: '/images/mama.png',module_id: 2 },
    { description: 'Esta es la seña para decir abuelo', content_link: '/images/abuelo.png',module_id: 2 },
    { description: 'Esta es la seña para decir papa', content_link: '/images/papa.png',module_id: 2 },
    { description: 'Hijo seña izquierda - Hija seña derecha', content_link: '/images/hijos.png',module_id: 2 },
    { description: 'Nieto seña izquierda - Nieta seña derecha', content_link: '/images/nietos.png',module_id: 2 }

    
    # Add more question data as needed
  ]

  cards_data.each do |data|
    description = Card.find_or_initialize_by(description: data[:description])
    description.assign_attributes(data)
    description.save
  end

  puts 'Cards added successfully!'
end



# Call the method to add questions
add_cards
