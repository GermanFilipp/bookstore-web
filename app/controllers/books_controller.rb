class BooksController < ApplicationController
  load_and_authorize_resource


  def index
    @books = @books.page params[:page]
    @categories = Category.all
  end

  def show
    @ratings = @book.ratings
  end

  def home
      @bestsellers = Book.bestsellers
  end

end