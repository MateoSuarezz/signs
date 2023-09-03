class Questions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
    	t.integer :question
    	t.boolean :answer
      t.string :content_link
      t.timestamps
    end 
  end
end
