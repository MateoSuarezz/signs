# frozen_string_literal: true

class ModificationPasword < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password
    add_column :users, :password_digest, :string
  end
end
