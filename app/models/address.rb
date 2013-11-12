class Address
  include Mongoid::Document

  field :street
  field :city
  field :state
  field :zip
  field :location

  index({ location: "2d" }, { min: -200, max: 200 })

  belongs_to :agency
end
