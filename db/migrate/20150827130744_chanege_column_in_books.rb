class ChanegeColumnInBooks < ActiveRecord::Migration
  def change
    change_column :books, :sold_count, :integer, default: 0
  end
end
