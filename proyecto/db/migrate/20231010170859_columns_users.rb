# frozen_string_literal: true

class ColumnsUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string
  end
end
