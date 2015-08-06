class Category < ActiveRecord::Base
  has_many  :books

  validates :title, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
