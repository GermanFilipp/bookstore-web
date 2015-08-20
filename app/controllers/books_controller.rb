class BooksController < ApplicationController
=begin
  before_action :authenticate_customer!
=end

  def index
    @books = Book.page params[:page]
    @categories = Category.all
  end

  def show
    @book = Book.find(params[:id])
    @ratings = Rating.get_rating(params[:id])
  end


end