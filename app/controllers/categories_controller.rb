class CategoriesController < ApplicationController
  before_action :authenticate_customer!

  def new
    duplicate_action
  end

  def show
    duplicate_action
  end


  private

  def duplicate_action
    @categories = Category.all
    @category = Category.find(params[:id])
    @books = Book.by_category(params[:id]).page params[:page]
  end
end
