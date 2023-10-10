class AddResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.belongs_to :users, null: false, foreign_key: true
      t.belongs_to :questions, null: false, foreign_key: true
      t.boolean :correct_answer, default: false
      t.timestamps
    end
  end
end