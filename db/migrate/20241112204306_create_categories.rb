class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.decimal :base_price
      t.decimal :minimum_cost
      t.decimal :additional_cost_per_gram

      t.timestamps
    end
  end
end
