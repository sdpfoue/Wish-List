class Topic
  include Mongoid::Document
  include Mongoid::Timestamps
  include StringExtensions
  
  field :title
  field :content
  field :tags, :type => Array
  field :closed, :type => Boolean
  field :replies_count, :type => Integer, :default => 0
  field :last_replied_at, :type => Time
  belongs_to :last_replied_by, :class_name=>'User'
  
  attr_accessible :title, :content, :tags
  
  validates_presence_of :title, :content
  validates_length_of :title, :maximum => 100
  validates_length_of :tags, :maximum => 5
  
  embeds_many :replies, :validate => false, :dependent => :delete
  belongs_to :user
  
  
  
  def tags=(value)
    if value.is_a? String
      write_attribute :tags, parse_tags_from_string(value)
    else
      write_attribute :tags, value.uniq
    end
  end
  
  def tags_string
    return tags.join(' ') unless tags.blank?
  end
  
end
