
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
20.times do
  title = Faker::Commerce.product_name
  description = Faker::Lorem.paragraph(5)
  price = Faker::Commerce.price
  quentity_books = Faker::Number.number(2)
  image = 'img_book' << rand(1..10).to_s << '.png'
  category_id = rand(1..5)
  author_id = rand(1..10)
  Book.create!(title: title,
               description: description,
               price: price,
               image: image,
               quentity_books: quentity_books,
               category_id: category_id,
               author_id: author_id)
end
5.times do
  category_title =  Faker::Commerce.product_name
  book_id = rand(1..5)
  Category.create!(
      title:category_title,
      book_id: book_id)
end
5.times do
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  biography = Faker::Lorem.paragraph
      Author.create!(
                first_name: first_name,
                last_name: last_name,
                biography: biography
      )
end
