# frozen_string_literal: true

class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.integer :card_id
      t.string :description
      t.string :content_link
    end
  end
end
