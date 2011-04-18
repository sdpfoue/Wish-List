class Wish
  include Mongoid::Document
  field :name, :type => String
  field :des, :type => String
  
  referenced_in :user
  referenced_in :space
end
