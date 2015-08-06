class ChangePasswordForm < Reform::Form
  property :password, presence: true
  property :password_confirmation, presence: true


end