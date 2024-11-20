class AddPaymentFieldsToPackages < ActiveRecord::Migration[7.2]
  def change
    add_column :packages, :payment_method, :string
    add_column :packages, :payment_status, :integer, default: 0
  end
end
