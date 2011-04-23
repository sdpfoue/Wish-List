class Follow
  include Mongoid::Document
  
  field :double, :type=>Boolean
  field :remark
  
  referenced_in :user #fan
  referenced_in :following, :class_name=>'User' #following
  
end
