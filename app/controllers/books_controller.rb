class BooksController < ApplicationController
  before_action :authenticate_customer!

  def index
    @books = Book.page params[:page]
    @categories = Category.all
  end

  def show
    @book = Book.find(params[:id])
    @ratings = Rating.get_rating(params[:id])
  end


end