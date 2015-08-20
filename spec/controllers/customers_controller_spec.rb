require 'rails_helper'

RSpec.describe CustomersController, type: :controller do

  let(:customer) {FactoryGirl.create :customer}
  let(:ability) { Ability.new(customer) }
  let(:address) {FactoryGirl.create :address}

  before do
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    sign_in customer
  end

  describe ' GET #edit' do

  end

  describe 'PUT #email' do

  end

  describe 'PUT #password'do

  end

  describe 'PUT #address'do

  end

  describe 'DELETE #destroy'do

  end
end
