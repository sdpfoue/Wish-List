class Timeline::Spacecomment < Timeline::Base

  
  field :space_name
  field :user_name

  belongs_to :comment, :class_name=>'Comment::Space'
  belongs_to :space
  
  #def message
  #  '=link_to(user_spaces_url(session[:user_id]))'#+'添加了'+wish_name+'到空间'+space_name
  #end
  

end
