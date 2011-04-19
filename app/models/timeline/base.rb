class Timeline::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_name
  include Mongoid::Document
  
  referenced_in :user
  
end
