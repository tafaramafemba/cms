class AddCategoryIdToPackages < ActiveRecord::Migration[7.2]
  def change
    add_column :packages, :category_id, :integer
  end
end
