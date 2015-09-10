class CategoriesController < ApplicationController
  load_and_authorize_resource


  def show
    @categories = Category.all
    @books = Book.by_category(params[:id]).page params[:page]
  end

end
