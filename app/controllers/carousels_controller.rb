class CarouselsController < ApplicationController
  def index
   @books = Book.first(5)
  end
end
