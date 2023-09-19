class DelAssessments < ActiveRecord::Migration[7.0]
  def change
    drop_table :assessments
  end
end
