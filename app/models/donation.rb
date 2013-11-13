class Donation
  include Mongoid::Document

  belongs_to :user, index: true

  field :category
  field :transaction_date, type: Date
  field :transaction_amount, type: BigDecimal

end