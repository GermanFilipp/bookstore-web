require 'rails_helper'

class FakesController < ApplicationController
  include StepsWizard
  include UpdateCustomer
end

describe FakesController do
  let(:controller) {FakesController.new}



  describe '#show_address' do

  end

end