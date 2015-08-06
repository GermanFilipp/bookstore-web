class Rating < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book

  validates :review, :rating,:title, presence: true
  validates_inclusion_of :rating, :in => 1..10

  def self.get_rating id
    where(book_id: id)
  end


  def self.add_review (review,rating,title,customer_id,book_id)
    create!(review: review,
            rating: rating,
            title: title,
            customer_id: customer_id,
            book_id: book_id)
  end

end
