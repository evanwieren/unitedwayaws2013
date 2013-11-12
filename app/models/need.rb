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

  def facebook_post(user)
    me = FbGraph::User.me(user.authentications.where(provider: "facebook").first.access_token)
    me.feed!(
      :message => "I am helping out on #{self.title}."
    )
  end
end
