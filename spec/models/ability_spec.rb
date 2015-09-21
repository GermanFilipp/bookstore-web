require 'rails_helper'

RSpec.describe Ability, type: :model do

  subject { ability }
  let(:ability){ Ability.new(customer) }

  describe 'abilities for not log in customer' do
    let(:customer){ nil }

    context 'for books' do
      it { expect(ability).to be_able_to(:index, Book) }
      it { expect(ability).to be_able_to(:show, Book) }
      it { expect(ability).to be_able_to(:home, Book) }
      it { expect(ability).not_to be_able_to(:create, Book) }
      it { expect(ability).not_to be_able_to(:update, Book) }
      it { expect(ability).not_to be_able_to(:destroy, Book) }
    end


    context 'for categories' do
      it { expect(ability).to be_able_to(:show, Category) }
      it { expect(ability).not_to be_able_to(:index, Category) }
      it { expect(ability).not_to be_able_to(:create, Category) }
      it { expect(ability).not_to be_able_to(:update, Category) }
      it { expect(ability).not_to be_able_to(:destroy, Category) }
    end

    context 'for rating' do
      it {expect(ability).not_to be_able_to(:create, Rating)}
      it {expect(ability).not_to be_able_to(:update, Rating)}
      it {expect(ability).not_to be_able_to(:destroy, Rating)}
      it {expect(ability).not_to be_able_to(:index, Rating)}
      it {expect(ability).not_to be_able_to(:show, Rating)}
      it {expect(ability).not_to be_able_to(:new, Rating)}
    end

    context 'for  delivery method' do
      it {expect(ability).not_to be_able_to(:create, DeliveryMethod)}
      it {expect(ability).not_to be_able_to(:update, DeliveryMethod)}
      it {expect(ability).not_to be_able_to(:destroy, DeliveryMethod)}
      it {expect(ability).not_to be_able_to(:index, DeliveryMethod)}
      it {expect(ability).not_to be_able_to(:show, DeliveryMethod)}
    end

    context 'for address' do
      it {expect(ability).not_to be_able_to(:create, Address)}
      it {expect(ability).not_to be_able_to(:update, Address)}
      it {expect(ability).not_to be_able_to(:destroy, Address)}
      it {expect(ability).not_to be_able_to(:index, Address)}
      it {expect(ability).not_to be_able_to(:show, Address)}
    end

    context 'for credit card' do
      it {expect(ability).not_to be_able_to(:create, CreditCard)}
      it {expect(ability).not_to be_able_to(:update, CreditCard)}
      it {expect(ability).not_to be_able_to(:destroy, CreditCard)}
      it {expect(ability).not_to be_able_to(:index, CreditCard)}
      it {expect(ability).not_to be_able_to(:show, CreditCard)}
    end

    context 'for order item' do
      it {expect(ability).not_to be_able_to(:create, OrderItem)}
      it {expect(ability).not_to be_able_to(:update, OrderItem)}
      it {expect(ability).not_to be_able_to(:destroy, OrderItem)}
      it {expect(ability).not_to be_able_to(:index, OrderItem)}
      it {expect(ability).not_to be_able_to(:show, OrderItem)}
      it {expect(ability).not_to be_able_to(:destroy_all, OrderItem)}
    end

    context 'for order' do
      it {expect(ability).not_to be_able_to(:create, Order)}
      it {expect(ability).not_to be_able_to(:update, Order)}
      it {expect(ability).not_to be_able_to(:destroy, Order)}
      it {expect(ability).not_to be_able_to(:index, Order)}
      it {expect(ability).not_to be_able_to(:show, Order)}
    end
  end
  describe 'abilities for log in customer' do
    let(:customer){ create(:customer) }

    context 'for books' do
      it { expect(ability).to be_able_to(:index, Book) }
      it { expect(ability).to be_able_to(:show, Book) }
      it { expect(ability).to be_able_to(:home, Book) }
      it { expect(ability).not_to be_able_to(:create, Book) }
      it { expect(ability).not_to be_able_to(:update, Book) }
      it { expect(ability).not_to be_able_to(:destroy, Book) }
    end


    context 'for categories' do
      it { expect(ability).to be_able_to(:show, Category) }
      it { expect(ability).not_to be_able_to(:index, Category) }
      it { expect(ability).not_to be_able_to(:create, Category) }
      it { expect(ability).not_to be_able_to(:update, Category) }
      it { expect(ability).not_to be_able_to(:destroy, Category) }
    end

    context 'for rating' do
      it {expect(ability).to be_able_to(:create, Rating)}
      it {expect(ability).not_to be_able_to(:update, Rating)}
      it {expect(ability).not_to be_able_to(:destroy, Rating)}
      it {expect(ability).not_to be_able_to(:index, Rating)}
      it {expect(ability).not_to be_able_to(:show, Rating)}
      it {expect(ability).to be_able_to(:new, Rating)}
    end

    context 'for  delivery method' do
      #it {expect(ability).to be_able_to(:read, DeliveryMethod)}
      it {expect(ability).to be_able_to(:show, DeliveryMethod)}
      it {expect(ability).to be_able_to(:index, DeliveryMethod)}
      it {expect(ability).not_to be_able_to(:create, DeliveryMethod)}
      it {expect(ability).not_to be_able_to(:update, DeliveryMethod)}
      it {expect(ability).not_to be_able_to(:destroy, DeliveryMethod)}
    end

    context 'for address' do
      it {expect(ability).to be_able_to(:create, Address)}
      it {expect(ability).to be_able_to(:update, Address)}
      it {expect(ability).not_to be_able_to(:destroy, Address)}
      it {expect(ability).to be_able_to(:show, Address)}
      it {expect(ability).to be_able_to(:index, Address)}
    end


    context 'for credit card' do
      #it {expect(ability).to be_able_to(:manage, CreditCard)}
      it {expect(ability).to be_able_to(:create, CreditCard)}
      it {expect(ability).to be_able_to(:update, CreditCard)}
      it {expect(ability).not_to be_able_to(:destroy, CreditCard)}
      it {expect(ability).to be_able_to(:show, CreditCard)}
      it {expect(ability).to be_able_to(:index, CreditCard)}
    end

    context 'for order item' do
      it {expect(ability).to be_able_to(:create, OrderItem)}
      it {expect(ability).to be_able_to(:update, OrderItem)}
      it {expect(ability).to be_able_to(:destroy, OrderItem)}
      it {expect(ability).to be_able_to(:index, OrderItem)}
      it {expect(ability).not_to be_able_to(:show, OrderItem)}
      it {expect(ability).to be_able_to(:destroy_all, OrderItem)}
    end

    context 'for order' do
      it {expect(ability).not_to be_able_to(:create, Order)}
      it {expect(ability).to be_able_to(:update, Order)}
      it {expect(ability).not_to be_able_to(:destroy, Order)}
      it {expect(ability).to be_able_to(:index, Order)}
      it {expect(ability).to be_able_to(:show, Order)}
    end

  end

end


