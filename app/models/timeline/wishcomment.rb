#encoding:utf-8

class Timeline::Wishcomment < Timeline::Base
 
  field :space_name
  field :user_name
  field :wish_owner
  field :wish_owner_id  

  belongs_to :comment, :class_name=>'Comment::Wish'
  belongs_to :wish
  
  #def message
  #  '=helpers.link_to(user_spaces_url(session[:user_id]))'#+'添加了'+wish_name+'到空间'+space_name
  #end
  

end
