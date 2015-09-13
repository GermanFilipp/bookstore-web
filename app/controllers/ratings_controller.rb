class RatingsController < ApplicationController
  authorize_resource
  before_action :setter

  def new
  end

  def create
   @rating = @book.ratings.create(rating_params)
   @rating.customer_id = current_customer.id
     if @rating.save
      redirect_to book_path  params[:book_id] , flash[:success] =  'Review was successfully added! '
     else
       flash[:danger] =  'Review was not added! Please fill all fields!'
       render action: 'new'
     end
  end

  private

  def rating_params
    params.require(:ratings).permit(:rating,:title, :review)
  end

  def setter
    @book = Book.find_by_id params[:book_id]
  end
end
