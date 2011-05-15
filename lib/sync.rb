module Sync
  include OAuth
  
  #sync message to douban
  def sync_to_douban(user,message)
    auth=user.get_auth('douban')
    @access_token = OAuth::AccessToken.new(
                        OAuth::Consumer.new(
                          "016fbfa638df0c66044f3ef2aa9d2532",  
                          "5675c3dcf1243fab", 
                          {
                            :site=>"http://api.douban.com",
                            :scheme=>:header,
                            :signature_method=>"HMAC-SHA1",
                            :realm=>"http://0.0.0.0:3000"
                          }
                      ),
                            auth['token'],
                            auth['secret']
                          )

    @response=@access_token.post "/miniblog/saying", %q{<?xml version='1.0' encoding='UTF-8'?>
      <entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
        <content>}+message+%q{</content>
      </entry>
    },  {"Content-Type" =>  "application/atom+xml"}
  end
  
  #sync message to sina
  def sync_to_tsina(user,message)
    auth=user.get_auth('tsina')
    consumer=OAuth::Consumer.new("3919887720", "e6b59529eaab69871633f37966419a81", :site => "http://api.t.sina.com.cn")
    access_token = OAuth::AccessToken.new(consumer, auth['token'],auth['secret'])
    url="http://api.t.sina.com.cn/statuses/update.xml"      
    response = access_token.request(:post, url, :status=>message)
  end
  
  #sync message to tqq 
  def sync_to_tqq(user, message, clientip)
    auth=user.get_auth('tqq')
    token=auth['token']
    secret=auth['secret']
     options={:site => "https://open.t.qq.com",
         :request_token_path  => "/cgi-bin/request_token", 
         :access_token_path   => "/cgi-bin/access_token",
         :authorize_path      => "/cgi-bin/authorize",
         :http_method         => :post,
         :scheme              => :query_string,
         :nonce               => Base64.encode64(OpenSSL::Random.random_bytes(32)).gsub(/\W/, '')[0, 32],
         :realm               => "http://0.0.0.0:3000",
         :clientip            => clientip,
         :content             => message,
         :format              => :json
        }
    
    consumer=OAuth::Consumer.new(
         "dd4c912b215443d4bd48b7d353ddf171", 
         "3576d325cc5b14933b1ef4231d41b9bc", 
         options)
    access_token = OAuth::AccessToken.new(consumer, token,secret)
    url="http://open.t.qq.com/api/t/add"      
    response = access_token.post(url, options)
  end
  
  #functions for sync to providers
  def sync_to_provider(user,provider,message,clientip)
    case provider
    when 'tsina'
      sync_to_tsina(user,message)
    when 'douban'
      sync_to_douban(user,message)
    when 'tqq'
      sync_to_tqq(user,message,clientip)
    end
  end
end
