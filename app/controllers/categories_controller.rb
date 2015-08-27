class CategoriesController < ApplicationController
  #load_and_authorize_resource


  def show
    @categories = Category.all
    @category = Category.find(params[:id])
    @books = Book.by_category(params[:id]).page params[:page]
  end

end
