require 'carrierwave/orm/activerecord'

class Book < ActiveRecord::Base
  paginates_per 8
  belongs_to :author
  belongs_to :category
  has_many   :ratings

  validates  :title, :price, :quentity_books, presence: true

  mount_uploader :image, ImageUploader


  def self.by_category id
    where(category_id: id)
  end

end
