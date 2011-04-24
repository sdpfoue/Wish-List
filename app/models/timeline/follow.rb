#encoding:utf-8

class Timeline::Follow < Timeline::Base
  field :follower_name
  field :following_name

  referenced_in :following,:class_name=>'User'

end
