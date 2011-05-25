class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content
  
  embedded_in :topic
  referenced_in :user
  
  attr_accessible :content
  
  validates_presence_of :content
  
  after_create :increment_counter, :add_replier_ids
  after_destroy :decrement_counter
  
  def increment_counter
    topic.inc :replies_count, 1
    topic.last_replied_by=user
    topic.last_replied_at=created_at
    topic.save
  end
  
  def add_replier_ids
    topic.reply_by self.user
  end

  
  def decrement_counter
    topic.inc :replies_count, -1
    if topic.last_replied_at==created_at
      topic.last_replied_at=topic.last.created_at 
      topic.last_replied_by=topic.last.user
    end
    topic.save
  end
  
  
end
