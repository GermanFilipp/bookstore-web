require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  let(:customer) {FactoryGirl.create :customer}
  let(:ability) { Ability.new(customer) }
  let(:book) {FactoryGirl.create :book}
  let(:category) {FactoryGirl.create :category}

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

  describe 'GET #show' do
    before do
      get :show, {id: category.id}
    end

    it 'receives find and return category' do
      expect(assigns(:category)).to eq category
    end

    it 'assigns @categories length' do

      expect(assigns(:categories).length).to eq(1)
    end

    it "assigns @books" do
      expect(assigns(:books)).to eq category.books.page(1)
    end



    it "render show template" do
      expect(response).to render_template("show")
    end

  end
end
