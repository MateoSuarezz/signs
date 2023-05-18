class CreateModules < ActiveRecord::Migration[7.0]
  def change
    create_table :modules do |t|
      t.string :name
      t.integer :point
      t.timestamps
    end
  end
end
