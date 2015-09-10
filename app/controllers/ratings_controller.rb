class RatingsController < ApplicationController
  load_and_authorize_resource

  def new
    @book = Book.find_by_id params[:book_id]
  end

  def create
    @book = Book.find_by_id params[:book_id]
     if @rating.update_attributes(rating_params)
      redirect_to book_path  params[:book_id] , flash[:success] =  'Review was successfully added'
     else
       render action: 'new'
     end
  end

  private

  def rating_params
    params.require(:ratings)
        .permit(:review, :rating, :title)
        .merge(book_id: params[:book_id], customer_id:current_customer.id)
  end
end
