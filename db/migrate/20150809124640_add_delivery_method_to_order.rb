class AddDeliveryMethodToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_method_id, :integer
    add_column :orders, :delivery_price, :decimal
  end
end
