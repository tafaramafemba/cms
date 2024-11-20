class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :id_number
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
