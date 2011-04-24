class Timeline::Base
  include Mongoid::Document
  include Mongoid::Timestamps
  #include ActionController::Base
  
  field :user_name
  field :content
  include Mongoid::Document
  
  referenced_in :user
  
  #return the timeline of following feed
  def self.get_following_timeline(user)
    any_in(user_id: User.find(user).get_following_users_id+[user]).desc(:created_at)
  end
  def print
  
  end
  
  #return public timeline
  def self.get_public_timeline
    all(sort:[[:created_at, :desc]])
  end
  
  def helpers
    ActionController::Base.helpers
  end
  
end
