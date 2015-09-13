require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:customer) { FactoryGirl.create(:customer) }
  let(:ability) { Ability.new(customer) }
  let(:book) { FactoryGirl.create(:book,id: 1) }

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end


  describe 'GET #new' do

    context 'cancan does not allow :new' do
      before do
        ability.cannot :new, Rating
        get :new, book_id: book.id
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    before do
      get :new, book_id: book.id
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

    context 'cancan does not allow :create' do
      before do
        ability.cannot :create, Rating
        post :create,book_id: book.id,ratings:FactoryGirl.attributes_for(:rating, book_id: book.id, customer_id: customer.id)
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end


    context 'with valid attributes' do
      it 'saves the new review in the database' do
        expect { post :create, book_id: book.id,
          ratings: FactoryGirl.attributes_for(:rating) }.to change(Rating, :count).by(1)
      end

      it 'assigns a success flash message' do
        post :create, book_id: book.id, ratings: FactoryGirl.attributes_for(:rating)
        expect(flash[:success]).not_to be_nil
      end

      it 'redirects to book show view' do
        post :create, book_id: book.id, ratings: FactoryGirl.attributes_for(:rating)
        expect(response).to redirect_to("/books/#{book.id}.Review%20was%20successfully%20added!%20")
      end
    end

    context 'with invalid attributes' do
      it 'does not save the review' do
        expect { post :create, book_id: book.id, ratings: FactoryGirl.attributes_for(:rating,
          review: '') }.to_not change(Rating, :count)
      end

      it 'assigns a danger flash message' do
        post :create, book_id: book.id, ratings: attributes_for(:rating, review: '')
        expect(flash[:danger]).not_to be_nil
      end

      it 'redirects to the book' do
        post :create, book_id: book.id, ratings: attributes_for(:rating, review: '')
        expect(response).to render_template 'new'
      end
    end


  end

end
