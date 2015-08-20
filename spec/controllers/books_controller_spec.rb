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

    it 'assigns @books' do
      books = create_list(:book,2)
      expect(assigns(:books)).to match_array(books)
    end

    it 'assigns @categories' do
      categories = create_list(:category, 10)
      expect(assigns(:categories)).to match_array(categories)
      expect(assigns(:categories).length).to eq(10)
    end

    it "renders index template" do
      expect(response).to render_template('index')
    end

  end


  describe "GET #show" do
    before do
      get :show, {id: book.id}
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

end