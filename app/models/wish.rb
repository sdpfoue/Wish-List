class Wish
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  
  field :comments_counter, :type=>Integer, :default=>0
  
  references_many :comments, :class_name=>'Comment::Wish',:dependent=>:delete
  references_many :timeline, :class_name=>'Timeline::Wish', :dependent=>:delete #delete
  referenced_in :user
  referenced_in :space
  
  after_create :counter_inc, :update_timeline
  after_destroy :counter_dec

protected

  def update_timeline
    @t=timeline.new(:user_id=>user.id,:space_id=>space.id,:wish_id=>self.id,
                 :user_name=>user.name, :wish_name=>self.name, :space_name=>space.name)
    @t.save
  end
  
  def counter_inc
    space.inc :wishes_counter,1
  end
  def counter_dec
    space.inc :wishes_counter, -1
  end
  
end
