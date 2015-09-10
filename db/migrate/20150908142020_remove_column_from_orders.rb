class RemoveColumnFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :billing_adress_id
    remove_column :orders, :shipping_adress_id
  end
end
