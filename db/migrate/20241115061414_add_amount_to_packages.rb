class AddAmountToPackages < ActiveRecord::Migration[7.2]
  def change
    add_column :packages, :amount, :decimal
  end
end
