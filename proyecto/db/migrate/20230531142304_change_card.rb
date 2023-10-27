# frozen_string_literal: true

class ChangeCard < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :card_id
  end
end
