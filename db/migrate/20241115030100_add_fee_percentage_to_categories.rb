class AddFeePercentageToCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :categories, :fee_percentage, :decimal
  end
end
