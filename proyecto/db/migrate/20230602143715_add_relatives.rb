class AddRelatives < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :module_id, :integer 
  end
end
