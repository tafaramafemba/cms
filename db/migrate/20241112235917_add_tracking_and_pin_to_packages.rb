class AddTrackingAndPinToPackages < ActiveRecord::Migration[7.2]
  def change
    add_column :packages, :tracking_number, :string
    add_column :packages, :collection_pin, :string
  end
end
