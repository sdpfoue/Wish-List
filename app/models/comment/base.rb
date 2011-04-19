class Comment::Base
  include Mongoid::Document
  include Mongoid::Timestamps  
  field :content, :type => String
  
  referenced_in :user
  
end
