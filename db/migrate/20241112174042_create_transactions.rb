class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.integer :package_id
      t.string :transaction_type
      t.string :reference
      t.string :for
      t.string :Send
      t.string :and
      t.string :Collect

      t.timestamps
    end
  end
end
