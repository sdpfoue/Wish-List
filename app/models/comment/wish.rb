class Comment::Wish<Comment::Base
  embedded_in :wish
  references_many :timeline, :class_name=>'Timeline::Wishcomment', :dependent=>:delete
  
  after_create :counter_inc, :update_timeline
  after_destroy :counter_dec
  
protected
  def counter_inc
    wish.inc :comments_counter, 1
  end
  
  def counter_dec
    wish.inc :comments_counter, -1
  end
  def update_timeline
    @t=wish.timeline_comment.new(:user_id=>user.id,:comment_id=>self.id,
                 :wish_owner=>wish.user.name,:wish_owner_id=>wish.user.id,
                 :user_name=>user.name, :wish_name=>wish.name, :content=>self.content)
    @t.save
  end
  
  
end
