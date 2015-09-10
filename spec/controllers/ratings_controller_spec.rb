require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:ability) { Ability.new(customer) }
  let(:book) { FactoryGirl.create(:book,id: 1) }
  let(:rating) {FactoryGirl.create(:rating, customer: customer, book: book)}
  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

##Some troubles - must remake this tests
  describe 'GET #new' do

    context 'cancan does not allow :new' do
      before do
        ability.cannot :new, Rating
        get :new
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end
    before do
      get :new, book_id: book.id
    end

    it 'assigns @rating variable' do
      expect(assigns(:rating)).to be_a_new(Rating)
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end

    context 'return book' do
      it "assigns @book" do
        expect(assigns(:book)).not_to be_nil
      end
    end
  end



  describe 'POST #create' do

    context 'cancan does not allow :index' do
      before do
        ratings = {title: "dk",review: "odkc", rating: '10'}

        ability.cannot :create, Rating
        post :create,ratings, book_id: book.id, customer_id: customer.id
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    ratings = {title: "dk",review: "odkc", rating: '10'}
    after { post :create, ratings, book_id: book.id, customer_id: customer.id }

    it 'create @rating' do
      expect(assigns(@rating)).not_to be_nil
    end

    it 'success flash' do
      post :create, book_id: book.id, customer_id: customer.id
      expect(flash[:success]).not_to be_nil
    end

    it 'redirect to book' do
      post :create, book_id: book.id, customer: customer.id
      expect(response).to redirect_to book_path(book.id)
    end

  end

end
