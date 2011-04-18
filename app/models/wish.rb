class Wish
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  
  references_many :comments, :class_name=>'Comment::Wish',:dependent=>:delete
  referenced_in :user
  referenced_in :space
end
