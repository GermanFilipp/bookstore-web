class AddLastNameRefToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :last_name, :string
  end
end
