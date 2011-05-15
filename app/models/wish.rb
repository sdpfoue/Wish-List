class Wish
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  field :tags, :type=>Array
  
  field :comments_counter, :type=>Integer, :default=>0
  
  attr_accessible :name, :des, :tags
  
  validates_presence_of :name, :des#, :tags
  validates_length_of :tags, :maximum => 5
  
  embeds_many :comments, :class_name=>'Comment::Wish',:dependent=>:delete
  references_many :timeline, :class_name=>'Timeline::Wish', :dependent=>:delete #delete
  references_many :timeline_comment,:class_name=>'Timeline::Wishcomment',:dependent=>:delete
  referenced_in :user
  referenced_in :space  
  
  after_create :counter_inc, :update_timeline
  after_destroy :counter_dec
  
  def tags_string
    return tags.join(' ') unless tags.blank?
  end

protected

  def tags=(value)
    if value.is_a? String
      write_attribute :tags, parse_tags_from_string(value)
    else
      write_attribute :tags, value.uniq
    end
  end

  def update_timeline
    @t=timeline.new(:user_id=>user.id,:space_id=>space.id,:wish_id=>self.id,
                 :user_name=>user.name, :wish_name=>self.name, :space_name=>space.name)
    @t.save
  end
  
  def counter_inc
    space.inc :wishes_counter,1
  end
  
  def counter_dec
    space.inc :wishes_counter, -1
  end
  
  def parse_tags_from_string(string)
    return [] if string==""
    tags = string.downcase.split
    tags.map! {|tag| tag.gsub "/", ""}
    tags.delete_if {|tag| tag.size > 20 or tag.empty? or tag == '.'}
    tags.uniq
  end  
  
end
