class Attendance

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :need

  field :user_id
  field :need_id

end