class Agency
  include Mongoid::Document

  field :id, :type => Integer
  field :name
  field :phone
  field :email

  has_many :needs
  has_many :addresses

  def main_address
    addresses.first
  end
end
