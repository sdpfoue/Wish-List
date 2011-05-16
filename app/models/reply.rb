class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content
  
  embedded_in :topic
  belongs_to :user
  
  attr_accessible :content
  
  validates_presence_of :content
  
  after_create :increment_counter
  after_destroy :decrement_counter
  
  def increment_counter
    topic.inc :replies_count, 1
  end
  
  def decrement_counter
    topic.inc :replies_count, -1
  end
  
  
end
