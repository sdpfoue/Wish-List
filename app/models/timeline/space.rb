class Timeline::Space < Timeline::Base
  field :space_name
  field :user_name

  
  referenced_in :space

end
