class Changequestions < ActiveRecord::Migration[7.0]
  def change
  
    rename_table :question, :questions 
    remove_column :questions, :question 
    add_column :questions, :question, :string
  
  end
end
