class AddRelatives < ActiveRecord::Migration[7.0]
  def change
    add_column :question, :module_id, :integer 
  end
end
