class AddCollectionPointAddressToCities < ActiveRecord::Migration[7.2]
  def change
    add_column :cities, :collection_point_address, :string
  end
end
