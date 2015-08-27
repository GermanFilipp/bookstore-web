class CreateDeliveryMethods < ActiveRecord::Migration
  def change
    create_table :delivery_methods do |t|
      t.string :name
      t.decimal :price
      t.integer :state

      t.timestamps null: false
    end
  end
end
