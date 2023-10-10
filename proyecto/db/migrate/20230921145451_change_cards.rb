class ChangeCards < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :module_id , :integer
  end
end
