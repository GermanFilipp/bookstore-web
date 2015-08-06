class AddBillingAddressRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :billing_adress, index: true
  end
end
