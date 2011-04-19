
class Space
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  field :access, :type => String
  
  references_many :wishes, :dependent => :delete
  references_many :comments,:dependent=>:delete,:class_name=>'Comment::Space'
  references_many :timeline, :class_name=>'Timeline::Space', :dependent=>:delete #delete
  referenced_in :user
  referenced_in :claimed_by, :class_name=>'User'
  
  field :wishes_counter, :type=>Integer, :default=>0
  field :comments_counter, :type=>Integer, :default=>0
  
  after_create  :update_timeline
  #after_destroy :decrement_counter_cache
  
protected

  def update_timeline
    @t=timeline.new(:user_id=>user.id,:space_id=>self.id,
                 :user_name=>user.name, :space_name=>self.name)
    @t.save
  end
  
end
