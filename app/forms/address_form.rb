class AddressForm
  include ActiveModel::Model
  include Virtus


  attribute :first_name, String
  attribute :last_name,  String
  attribute :address,    String
  attribute :zipcode,    String
  attribute :city,       String
  attribute :phone,      String


end