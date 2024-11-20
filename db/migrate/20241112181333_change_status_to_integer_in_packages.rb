class ChangeStatusToIntegerInPackages < ActiveRecord::Migration[6.1]
  def change
    change_column :packages, :status, :integer, using: 'status::integer', default: 0
  end
end
