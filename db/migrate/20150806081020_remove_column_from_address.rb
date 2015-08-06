class RemoveColumnFromAddress < ActiveRecord::Migration
  def change
    remove_column :addresses, :country
  end
end
