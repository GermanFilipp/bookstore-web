require 'rails_helper'

RSpec.describe CarouselsController, type: :controller do

  let(:book) {FactoryGirl.create :book}
  let(:customer) {FactoryGirl.create :customer}
  let(:ability) { Ability.new(customer) }

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end
  describe 'GET #index' do
    before do
       get :index
       create_list(:book,5)
    end
=begin
    it 'must return five first books' do
      expect(assigns(:books)).to match_array Book.first(5)
    end
=end

    it "renders index template" do
      expect(response).to render_template('index')
    end

  end
end
