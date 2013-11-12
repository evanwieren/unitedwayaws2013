class Authentication

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user

  field :user_id
  field :provider
  field :uid
  field :access_token
  field :access_secret

end