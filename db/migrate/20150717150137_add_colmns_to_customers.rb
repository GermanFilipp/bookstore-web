class AddColmnsToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :uid, :string
  end
end
