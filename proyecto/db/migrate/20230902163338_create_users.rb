class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    reate_table :users do |t|
    	t.string :email 
    	t.string :password
      t.int :points
      t.timestamps
    end 
  end
end
