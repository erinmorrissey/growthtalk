class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|

      t.string :name
      t.string :url
      t.string :logo_image

      t.timestamps null: false
    end
  end
end
