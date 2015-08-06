class AddShippingAddressRefToOrders < ActiveRecord::Migration
  def change
      add_reference :orders, :shipping_adress, index: true
  end
end
