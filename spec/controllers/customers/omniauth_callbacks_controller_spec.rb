require 'rails_helper'

RSpec.describe Customers::OmniauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
  end

  it "calls Customer.from_omniauth" do
    customer = create :facebook_customer
    expect(Customer).to receive(:from_omniauth).and_return(customer)
    get :facebook
  end

  it "redirect to sign up page if given information not enough" do
    customer = build(:facebook_customer, first_name: nil)
    allow(Customer).to receive(:from_omniauth).and_return(customer)
    get :facebook
    expect(response).to redirect_to new_customer_registration_path
  end
end