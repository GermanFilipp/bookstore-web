require 'rails_helper'

RSpec.describe BooksController, type: :controller do

  let(:book) {FactoryGirl.create :book}
  let(:customer) {FactoryGirl.create :customer}
  let(:ability) { Ability.new(customer) }
  let(:category) {FactoryGirl.create :category}
  let(:rating) {FactoryGirl.create :rating,book: book}

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

  describe 'GET #index' do
    before { get :index }

    context 'cancan does not allow :index' do
      before do
        ability.cannot :index, Book
        get :index
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    it 'assigns @books' do
      books = create_list(:book,2)
      expect(assigns(:books)).to match_array(books)
    end


    it 'assigns @categories' do
      categories = create_list(:category, 2)
      expect(assigns(:categories)).to match_array(categories)
      expect(assigns(:categories).length).to eq(2)
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end

  end


  describe "GET #show" do
    before do
      get :show, {id: book.id}
    end

    context 'cancan does not allow :show' do
      before do
        ability.cannot :show, Book
        get :show, {id: book.id}
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end

    it "assigns @book to book" do
      expect(assigns(:book)).to eq(book)
    end

    it 'assigns @ratings to rating' do
      expect(assigns(:ratings)).to match_array(rating)
    end

    it "render show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET #home" do
    before do
      get :home
    end

    context 'cancan does not allow :show' do
      before do
        ability.cannot :home, Book
        get :home
      end
      it { expect(response).to redirect_to(new_customer_session_path) }
    end
    FactoryGirl.create_list(:book,10, sold_count:5)

    it 'must return five first books' do
      expect(assigns(:books)).to match_array Book.bestsellers
    end

    it "renders home template" do
      expect(response).to render_template('home')
    end
  end


end