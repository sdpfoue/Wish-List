class Comment::Space<Comment::Base
  referenced_in :space
  
  after_create :counter_inc
  after_destroy :counter_dec
  
protected
  def counter_inc
    space.inc :comments_counter, 1
  end
  
  def counter_dec
    space.inc :comments_counter, -1
  end
  
end
