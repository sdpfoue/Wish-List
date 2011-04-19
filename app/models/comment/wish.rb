class Comment::Wish<Comment::Base
  referenced_in :wish
  #referenced_in :user
  
  after_create :counter_inc
  after_destroy :counter_dec
  
protected
  def counter_inc
    wish.inc :comments_counter, 1
  end
  
  def counter_dec
    wish.inc :comments_counter, -1
  end

  
  
end
