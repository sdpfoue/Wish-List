class Timeline::Wish < Timeline::Base

  field :wish_name
  field :space_name

  referenced_in :wish
  referenced_in :space
  

end