class Customers::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
   @customer = Customer.from_omniauth(request.env['omniauth.auth'])
#    if @customer.persisted?
        sign_in_and_redirect @customer, notice: "Signed in!"
=begin
    else
        session['devise.customer_attributes'] = @customer.attributes
        redirect_to new_customer_registration_url
    end
=end
  end



  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
