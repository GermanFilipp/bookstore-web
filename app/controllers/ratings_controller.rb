class RatingsController < ApplicationController

  def new
    @book = Book.where(id: params[:book_id])
    @rating = Rating.new
  end

  def create
    @book = Book.where(id: params[:book_id])
    @ratings = Rating.add_review(rating_params[:review],rating_params[:rating],
                                 rating_params[:title],rating_params[:customer_id],
                                 rating_params[:book_id])

    redirect_to book_path(params[:book_id])
  end

  private

  def rating_params
    params.require(:ratings).permit(:review, :rating,
                                   :title, :book_id, :customer_id )
  end

end
