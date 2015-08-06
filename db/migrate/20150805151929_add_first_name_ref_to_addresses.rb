class AddFirstNameRefToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :first_name, :string
  end
end
