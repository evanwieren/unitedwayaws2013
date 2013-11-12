class Need
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :description
  field :category
  belongs_to :agency

  def to_search
    {
      :title => title,
      :desc => description,
      :lat => agency.main_address.location[0],
      :lng => agency.main_address.location[1]
    }
  end
end
