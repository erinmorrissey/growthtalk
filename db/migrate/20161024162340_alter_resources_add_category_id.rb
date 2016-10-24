class AlterResourcesAddCategoryId < ActiveRecord::Migration
  def change
    add_column :resources, :category_id, :integer
    add_index :resources, :category_id
  end
end
