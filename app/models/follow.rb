class Follow
  include Mongoid::Document
  
  field :double, :type=>Boolean
  field :remark
  
  referenced_in :user #fan
  referenced_in :following, :class_name=>'User' #following
  references_many :timeline,:class_name=>'Timeline::Follow',:dependent=>:delete
  
  validate :can_only_follow_once
  
  after_create :inc_counter, :update_timeline
  after_destroy :dec_counter
  
  def update_timeline
    #@t=timeline.new(:user_id=>user.id,:follower_name=>user.name, 
    #              :following_name=>following.name,:following_id=>following.id)
    @t=timeline.new(:user_id=>user.id,:follower_name=>user.name, 
                    :following_id=>following.id, :following_name=>following.name)    
    @t.save
  end
  
  def self.all_followers(user)
    fs=all_in(following_id:[user.id])
    fs.map{|f| f.user}
  end
  def can_only_follow_once
    errors.add(:user,:following) if Follow.where(user_id: user_id).and(following_id: following_id).first
  end
  
  def self.all_following(user)
    fs=all_in(user_id:[user.id])
    fs.map{|f| f.following}
  end
  
  def self.followed?(fan,following)
    !!Follow.where(user_id: fan).and(following_id: following).first
  end
  
  def self.unfo(fan_id,following_id)
    Follow.where(user_id: fan_id).and(following_id: following_id).first.destroy
  end
  
protected
  def inc_counter
    user.inc :following_counter, 1
    following.inc :follower_counter, 1
  end
  
  def dec_counter
    user.inc :following_counter, -1
    following.inc :follower_counter, -1
  end
  
end
