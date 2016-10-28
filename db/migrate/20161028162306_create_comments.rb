class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment_text
      t.integer :resource_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :comments, [:user_id, :resource_id]
    add_index :comments, :resource_id
  end
end
