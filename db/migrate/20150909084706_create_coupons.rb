class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :number
      t.decimal :price

      t.timestamps null: false
    end
  end
end
