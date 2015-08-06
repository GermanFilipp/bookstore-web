class AddBookRefToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :book, index: true, foreign_key: true
  end
end
