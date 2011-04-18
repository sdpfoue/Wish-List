class Space
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  field :access, :type => String
  field :wishes_count, :type=>Integer, :default=>0
  
  references_many :wishes, :dependent => :delete
  referenced_in :user
  referenced_in :claimed_by, :class_name=>'User'
  
end
