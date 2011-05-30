class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  include StringExtensions
  gravtastic :rating => 'G', :size => 48
  
  field :name, :type => String
  field :email, :type => String
  field :password, :type => String
  field :remember_token, :type => String
  field :remember_token_expires_at, :type => Time
  field :banned, :type => Boolean
  field :remember, :type=>Boolean
  field :reg_ip
  field :following_counter, :default=>0
  field :follower_counter, :default=>0
  field :interested_tags, :type => Array
  
  attr_accessible :name, :email,:psd
  
  attr_accessor :password_confirmation
  attr_reader :psd,:remember_me
  
  references_many :spaces
  references_many :wishes
  
  embeds_many :authorizations
  
  validates_presence_of :name, :email
  validates_presence_of :psd,:if => Proc.new {|user| user.requrie_password?}
  #validates_length_of :psd, :minimum => 6, :allow_blank => true
  validates_uniqueness_of :name, :email, :case_sensitive => false
  UsernameRegex = /\A\w{3,20}\z/
  validates_format_of :name, :with => UsernameRegex
  #validates_format_of :locale, :with => /\A(#{AllowLocale.join('|')})\Z/, :allow_blank => true
  #validates_presence_of :psd
  validates_length_of :psd, :in => 6..20, :allow_blank => true

  
  def remember_me=(r)
    if r=='1'
      remember_me_for 4.weeks
    else
      self.remember=false
    end
  end
  
  def get_followers
    Follow.all_followers(self)
  end
  
  #return a array of following user object
  def get_following
    #Follow.all_in(user_id:[id])
    Follow.all_following(self)
  end
  
  #return a array of following user id
  def get_following_users_id
    get_following.map{|f| f.id}
  end

  def remember_me_for(time)
    self.remember=true
    remember_me_until time.from_now.utc
  end
  
  def remember_me_until(time)
    self.remember_token            = make_token
    self.remember_token_expires_at = time
  end
  
  def reset_access_token
    self.access_token = make_token
  end
  
  def make_token
    User.secure_digest(Time.now, (1..10).map{ rand.to_s }, self.name, self.email)
  end  


  def self.secure_digest(*args)
    Digest::SHA2.hexdigest(args.flatten.join)
  end
  
  def User.user_exists_by_name?(user_name)
	!!User.where(name: user_name).first
  end
  
  def psd=(psd)
    @psd=psd
    self.password=self.class.encrypt_password(psd) if psd.present?
  end

  def User.encrypt_password(password)
    Digest::SHA2.hexdigest(password)
  end  
  
  def User.authenticate(email, password)    
    psd=self.encrypt_password(password)
    find(:first,:conditions => {:email=>email,:password=>psd})||
      find(:first,:conditions => {:name=>email,:password=>psd})
  end
  
  def User.session_auth(email, password)
    if user=find_by_email(email)
      if user.password==password
        user
      end
    end
  end
  def requrie_password?
    new_record? or @recovering
  end
  
  def get_auth(provider)
    authorizations.where(:provider=>provider).first
  end
  
  def self.get_users_by_name(userlist)
    any_in(name: userlist)   
  end
  
  def add_interested_tags(tags)
    @new_tags = parse_tags_from_string(tags) - interested_tags.to_a
    self.interested_tags ||= []
    self.interested_tags += @new_tags
    #print interested_tags
    save!
  end
  def remove_interested_tags(tags)
    @destroy_tags = parse_tags_from_string(tags)
    self.interested_tags -= @destroy_tags unless self.interested_tags==nil
    #print interested_tags
    save!
  end
  
end
