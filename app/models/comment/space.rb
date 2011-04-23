class Comment::Space<Comment::Base
  referenced_in :space
  references_many :timeline, :class_name=>'Timeline::Spacecomment', :dependent=>:delete
  
  after_create :counter_inc, :update_timeline
  after_destroy :counter_dec
  
protected
  def update_timeline
    @t=space.timeline_comment.new(:user_id=>user.id,:comment_id=>self.id,
                 :space_owner=>space.user.name,:space_owner_id=>space.user.id,
                 :user_name=>user.name, :space_name=>space.name, :content=>self.content)
    @t.save
  end
  def counter_inc
    space.inc :comments_counter, 1
  end
  
  def counter_dec
    space.inc :comments_counter, -1
  end
  
end
