
class Space
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  field :access, :type => String
  field :privacy
  field :allowed_users, :type=>Array
  
  references_many :wishes, :dependent => :delete
  embeds_many :comments,:dependent=>:delete,:class_name=>'Comment::Space'
  references_many :timeline, :class_name=>'Timeline::Space', :dependent=>:delete #delete
  references_many :timeline_comment, :class_name=>'Timeline::Spacecomment', :dependent=>:delete
  referenced_in :user
  referenced_in :claimed_by, :class_name=>'User'
  
  field :wishes_counter, :type=>Integer, :default=>0
  field :comments_counter, :type=>Integer, :default=>0
  
  after_create  :update_timeline
  #after_destroy :decrement_counter_cache
  
  def get_privacy
    self.privacy
  end
  
protected

  def update_timeline
    @t=timeline.new(:user_id=>user.id,:space_id=>self.id,
                 :user_name=>user.name, :space_name=>self.name)
    @t.save
  end
  
  def parse_user(string)
    users = string.split
    users.uniq
    users.map! {|user| user.gsub "/", ""}
    users.delete_if {|user| !User.user_exists_by_name?(user)}    
  end
  
end
