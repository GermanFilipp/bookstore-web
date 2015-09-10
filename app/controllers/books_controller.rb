class BooksController < ApplicationController
  load_and_authorize_resource


  def index
    @books = @books.page params[:page]
    @categories = Category.all
  end

  def show
    @ratings = Rating.get_rating(params[:id])
  end

  def home
    @books = Book.bestsellers
  end

end