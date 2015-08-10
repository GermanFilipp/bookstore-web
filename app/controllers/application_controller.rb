class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_customer!
  helper_method :current_customer_order, :countries
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_customer)
  end

  def current_customer_order
   current_customer.order_in_progress unless current_customer.nil?
  end

  def countries
    @countries ||= Country.order(:name).map{|country| [country.name, country.id]}
  end

end
