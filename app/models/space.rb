
class Space
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  field :access, :type => String
  field :privacy
  field :allowed_users, :type=>Array
  
  attr_accessible :allowed_users, :name, :des, :privacy
  
  validates_presence_of :name, :des, :privacy
  
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
  
  def allowed_users=(string)
    if string.is_a? String
      write_attribute :allowed_users, parse_users_from_string(string)
    else
      write_attribute :allowed_users, string.uniq
    end
  end
  
  def allowed_users_string
    return allowed_users.join(' ') unless allowed_users.blank?
  end
  
  def isallowed?(uid,user_name)
    return true if uid==user_id
    case privacy
    when 'onlyme'
      uid==user.id
    when 'following'
      Follow.following?(uid,user.id)
    when 'selected'
      return true if allowed_users.include?(user_name)
    when 'public'
      true    
    end
  end
  
  def get_privacy
    privacy  
  end
  
protected

  def update_timeline
    @t=timeline.new(:user_id=>user.id,:space_id=>self.id,
                 :user_name=>user.name, :space_name=>self.name)
    @t.save
  end
  
  def parse_users_from_string(string)
    users = string.split
    users.uniq
    users.map! {|user| user.gsub "/", ""}
    users.delete_if {|user| !User.user_exists_by_name?(user)}    
  end
  
end
