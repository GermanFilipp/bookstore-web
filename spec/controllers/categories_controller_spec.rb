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
      Category.stub(:find).and_return category
    end

    it 'receives find and return category' do
      expect(Category).to receive(:find).with(category.id)
    end

    it 'assigns @categories length' do

      expect(assigns(:categories).length).to eq(1)
    end




    it "render show template" do
      expect(response).to render_template("show")
    end

  end
end
