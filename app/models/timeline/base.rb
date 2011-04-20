class Timeline::Base
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_name
  field :content
  include Mongoid::Document
  
  referenced_in :user
  
end
