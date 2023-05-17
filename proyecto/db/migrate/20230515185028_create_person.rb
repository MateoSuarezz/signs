class CreatePerson < ActiveRecord::Migration[7.0]
  def change
    create_table :person do |t|
      t.string :name
      t.string :mail 
      t.string :password
    end 
  end
end