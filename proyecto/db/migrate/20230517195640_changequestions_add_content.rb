class ChangequestionsAddContent < ActiveRecord::Migration[7.0]
  def change
  	add_column :questions, :content_link, :string
  end
end
