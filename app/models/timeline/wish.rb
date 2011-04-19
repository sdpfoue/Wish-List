class Timeline::Wish < Timeline::Base

  field :wish_name
  field :space_name
  field :user_name

  referenced_in :wish
  referenced_in :space
  
  #def message
  #  '=link_to(user_spaces_url(session[:user_id]))'#+'添加了'+wish_name+'到空间'+space_name
  #end
  

end
