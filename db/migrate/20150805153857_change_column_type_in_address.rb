class ChangeColumnTypeInAddress < ActiveRecord::Migration
  def change
    change_column :addresses, :zipcode, :string
  end
end
