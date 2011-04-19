
class Space
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, :type => String
  field :des, :type => String
  field :access, :type => String
  
  references_many :wishes, :dependent => :delete
  references_many :comments,:dependent=>:delete,:class_name=>'Comment::Space'
  referenced_in :user
  referenced_in :claimed_by, :class_name=>'User'
  
  field :wishes_counter, :type=>Integer, :default=>0
  field :comments_counter, :type=>Integer, :default=>0
  
  #after_create  :increment_counter_cache
  #after_destroy :decrement_counter_cache
  
protected
def increment_counter_cache(val = 1)
    db = Mongoid::Config.instance.master
    self.class.counters.each do |counter|
      db[counter[:table]].update({"_id" => send(counter[:association]).id}, {'$inc' => { counter[:field] => val } });
    end
  end

  def decrement_counter_cache
    increment_counter_cache(-1)
  end
  
end
