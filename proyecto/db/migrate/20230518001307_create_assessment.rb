class CreateAssessment < ActiveRecord::Migration[7.0]
  def change
    create_table :assessments do |t|
      t.belongs_to :user
      t.integer :correct_answers
      t.timestamps
    end
  end
end
