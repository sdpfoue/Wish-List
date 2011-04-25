class Comment::Base
  include Mongoid::Document
  include Mongoid::Timestamps  
  field :content, :type => String
  field :user_name
  
  referenced_in :user
  
end
