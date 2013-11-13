class Address
  include Mongoid::Document

  field :street
  field :city
  field :state
  field :zip
  field :location

  index({ location: "2d" })

  belongs_to :agency
end
