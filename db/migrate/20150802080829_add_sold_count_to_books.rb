class AddSoldCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :sold_count, :integer
  end
end
