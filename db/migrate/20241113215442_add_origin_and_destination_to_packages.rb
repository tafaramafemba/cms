class AddOriginAndDestinationToPackages < ActiveRecord::Migration[7.2]
  def change
    add_reference :packages, :origin_city, null: false, foreign_key: { to_table: :cities }
    add_reference :packages, :destination_city, null: false, foreign_key: { to_table: :cities }
  end
end
