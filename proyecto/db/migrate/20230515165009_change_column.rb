class ChangeColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :question, :answer, :boolean
  end
end
