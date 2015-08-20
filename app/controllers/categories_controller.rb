class CategoriesController < ApplicationController
  before_action :authenticate_customer!


  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @books = Book.by_category(params[:id]).page params[:page]
  end

end
