class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  gravtastic :rating => 'G', :size => 48
  
  field :name, :type => String
  field :email, :type => String
  field :password, :type => String
  field :remember_token, :type => String
  field :remember_token_expires_at, :type => Time
  field :banned, :type => Boolean
  field :remember, :type=>Boolean
  field :reg_ip
  
  attr_accessor :password_confirmation
  attr_reader :psd,:remember_me
  
  references_many :spaces
  references_many :wishes
  
  validates_presence_of :name, :email
  #validates_presence_of :password, :if => Proc.new {|user| user.requrie_password?}
  validates_presence_of :psd
  validates_length_of :psd, :minimum => 6
  validates_uniqueness_of :name, :email, :case_sensitive => false
  UsernameRegex = /\A\w{3,20}\z/
  validates_format_of :name, :with => UsernameRegex
  #validates_format_of :locale, :with => /\A(#{AllowLocale.join('|')})\Z/, :allow_blank => true
  validates_presence_of :psd
  validates_length_of :psd, :in => 6..20

  
  def remember_me=(r)
    if r=='1'
      remember_me_for 4.weeks
    else
      self.remember=false
    end
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
  
end
