class Questions < ActiveRecord::Migration[7.0]
  def change
    create_table :question do |t|
    	t.integer :question
    	t.boolean :answer
    end 
  end
end
