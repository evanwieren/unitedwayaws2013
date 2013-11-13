class Need
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :description
  field :category
  field :attending_count, type: Integer, default: 0
  belongs_to :agency
  has_many :attendances

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

  def twitter_post(user)
    twitter = user.authentications.where(provider: "twitter").first
    client = Twitter::Client.new(:oauth_token => twitter.access_token, :oauth_token_secret => twitter.access_secret)
    client.update("I am helping out on #{self.title}.")
  end
end
