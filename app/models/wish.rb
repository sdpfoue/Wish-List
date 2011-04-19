class Wish
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  
  field :comments_counter, :type=>Integer, :default=>0
  
  references_many :comments, :class_name=>'Comment::Wish',:dependent=>:delete
  referenced_in :user
  referenced_in :space
  
  after_create :counter_inc
  after_destroy :counter_dec
protected
  def counter_inc
    space.inc :wishes_counter,1
  end
  def counter_dec
    space.inc :wishes_counter, -1
  end
  
end
